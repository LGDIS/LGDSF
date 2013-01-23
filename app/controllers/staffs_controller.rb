# encoding: utf-8
class StaffsController < ApplicationController
  before_filter :authenticate_user!, :only => 'index'

  skip_before_filter :check_if_login_required, :except => :index

  layout :layout_selector

  trans_sid

  # レイアウトの選択処理
  # ==== Args
  # _params[:action]_ :: URL（パス）
  # ==== Return
  # ==== Raise
  def layout_selector
    case params[:action]
    when 'mail'
      'lgdsf'
    when 'index'
      'lgdsf_redmine'
    when 'position_form'
      request.mobile? ? 'lgdsf_mobile' : 'lgdsf_smartphone_position'
    when 'destination_form'
      request.mobile? ? 'lgdsf_mobile' : 'lgdsf_smartphone_map'
    else
      request.mobile? ? 'lgdsf_mobile' : 'lgdsf_smartphone'
    end
  end

  # メールのアクション
  # ==== Args
  # ==== Return
  # ==== Raise
  def mail
  end

  # 個人特定情報送信画面
  # 読み込み処理
  # ==== Args
  # _params[:mail_id]_ :: 災害番号
  # ==== Return
  # ==== Raise
  def send_form
    @mail_id = params[:mail_id]
    if request.mobile?
      render "send_form_mobile"
    else
      render
    end
  end

  # 個人特定情報送信画面
  # 書き込み処理
  # ==== Args
  # _params[:mail]_ :: メールアドレス
  # _params[:mail_id]_ :: 災害番号
  # ==== Return
  # ==== Raise
  def save_send
    @mail = params[:mail]
    @mail_id = params[:mail_id]

    # メールアドレス認証
    if @mail['mail_address'].present?

      @agent = Agent.find_by_mail_address(@mail['mail_address'])

      if @agent.present?
        # 認証成功の場合
        @staff = Staff.find_by_agent_id_and_mail_id(@agent.id, @mail_id)
        if @staff.present?
          # 上書き
          @staff.name = @agent.name
          @staff.agent_id = @agent.id
        else
          # 挿入
          @staff =Staff.new(:name => @agent.name, :agent_id => @agent.id, :mail_id => @mail_id)
        end
        if @staff.save
          redirect_to :action  =>"position_form", :mail_id => @mail_id, :agent_id => @agent.id
        else
          # 認証エラーの場合
          @notice = "認証に失敗しました"
          redirect_to :action => 'send_form', :mail_id => @mail_id, :notice => @notice
        end
      else
        # 認証エラーの場合
        @notice = "認証に失敗しました"
        redirect_to :action => 'send_form', :mail_id => @mail_id, :notice => @notice
      end
    else
      # 認証エラーの場合
      @notice = "メールアドレスを入力してください"
      redirect_to :action => 'send_form', :mail_id => @mail_id, :notice => @notice
    end
  end

  # 位置情報送信画面
  # 読み込み処理
  # ==== Args
  # _params[:mail_id]_ :: 災害番号
  # _params[:agent_id]_ :: 職員ID
  # ==== Return
  # ==== Raise
  def position_form
    @mail_id = params[:mail_id]
    @agent_id = params[:agent_id]
    if request.mobile?
      render "position_form_mobile"
    else
      render
    end
  end

  # 位置情報送信画面
  # 書き込み処理
  # ==== Args
  # _params[:mail_id]_ :: 災害番号
  # _params[:agent_id]_ :: 職員ID
  # ==== Return
  # ==== Raise
  def save_position
    @mail_id = params[:mail_id]
    @agent_id = params[:agent_id]

    # 現在位置の取得
    if request.mobile? and request.mobile.position
      @latitude = request.mobile.position.lat
      @longitude = request.mobile.position.lon
    else
      @latitude = params[:latitude]
      @longitude = params[:longitude]
    end

    if @latitude.present? && @longitude.present?

      @staff = Staff.find_by_agent_id_and_mail_id(@agent_id, @mail_id)

      if @staff.present?
        # 上書き
        @staff.latitude = @latitude
        @staff.longitude = @longitude
      else
        # 挿入
        @agent = Agent.find(@agent_id)
        @staff =Staff.new(:name => @agent.name, :agent_id => @agent_id, :latitude => @latitude, :longitude => @longitude, :mail_id => @mail_id)
      end

      if @staff.save
        # 現在位置送信成功時の場合
        redirect_to :action => "destination_form", :agent_id => @agent_id, :latitude => @latitude, :longitude => @longitude, :mail_id => @mail_id
      else
        # 現在位置送信失敗時の場合
        @notice = "認証に失敗しました"
        redirect_to :action => 'position_form', :mail_id => @mail_id, :agent_id => @agent_id, :notice => @notice
      end
    else
      # 現在位置送信失敗時の場合
      @notice = "現在位置の取得に失敗しました"
      redirect_to :action => 'position_form', :mail_id => @mail_id, :agent_id => @agent_id, :notice => @notice
    end

  end

  # 参集場所報告画面
  # 読み込み処理
  # ==== Args
  # _params[:mail_id]_ :: 災害番号
  # _params[:agent_id]_ :: 職員ID
  # _params[:latitude]_ :: 緯度
  # _params[:longitude]_ :: 経度
  # ==== Return
  # ==== Raise
  def destination_form
    @all_shelters = Shelter.find(:all)
    @mail_id = params[:mail_id]
    @agent_id = params[:agent_id]
    @latitude = params[:latitude].to_f
    @longitude = params[:longitude].to_f
    @zoom = 15

    # 近くの参集場所の計算
    diffs = []
    size = request.mobile? ? 200.0 : 350.0

    # 2点間の距離を求める
    @all_shelters.each_with_index do |shelter, count|
      lat = shelter.latitude - @latitude
      lng = shelter.longitude - @longitude
      diffs[count] = Math::sqrt(lat * lat + lng * lng)
      @zoom = Math::log(size/diffs[count])/Math::log(2) < @zoom ? Math::log(size/diffs[count])/Math::log(2) : @zoom
    end

    temps = []
    temps = diffs.sort

    # ズームの微調整
    @zoom = @zoom.round - 1

    # 参集場所の取得
    place = PredefinedPosition.find_by_agent_id(@agent_id)

    # id は配列の番号なので実際には+1した値がID
    # 所定の参集場所IDを初期値として代入しておく。
    shelters_id = []
    shelters_id.push(place.shelter_id)

    # モバイル・スマートフォンにより、近くの参集場所の表示数を分ける
    roop = request.mobile? ? 3 : 8

    # 近くの参集場所を近い順に並べる
    for i in 0...roop
      diffs.each_with_index do |diff, count|
        if temps[i] == diff
          unless shelters_id.include?(count + 1)
            shelters_id[i+1] = count + 1
            break
          end
        end
      end
    end

    # 所定の参集場所、近くの参集場所を@shelters変数に格納する。
    @shelters = []
    shelters_id.each_with_index do |shelter_id, count|
      @shelters.push(Shelter.find(shelter_id))
    end

    if request.mobile?
      render "destination_form_mobile"
    else
      render
    end
  end

  # 参集場所報告画面
  # 書き込み処理
  # ==== Args
  # _params[:destination]_ :: 参集場所情報
  # _params[:mail_id]_ :: 災害番号
  # _params[:agent_id]_ :: 職員ID
  # _params[:latitude]_ :: 緯度
  # _params[:longitude]_ :: 経度
  # ==== Return
  # ==== Raise
  def save_destination
    @destination = params[:destination]
    @agent_id = params[:agent_id]
    @mail_id = params[:mail_id]
    @latitude = params[:latitude]
    @longitude = params[:longitude]

    p @destination['place']

    if @destination['position'].present? || @destination['place'].to_i == 1 

      @staff = Staff.find_by_agent_id_and_mail_id(@agent_id, @mail_id)

      if @staff.present?
        # 上書き
        if @destination['place'].to_i == 1
          @staff.status = false
        else
          @staff.status = true
          shelter = Shelter.find(@destination['position'])
          @staff.destination = shelter.name
        end
        @staff.reason = @destination['reason'] if @destination['reason'].present?
      else
        # 挿入（エラー処理）
        @notice = "参集先情報の送信に失敗しました"
        redirect_to :action => "destination_form", :agent_id => @agent_id, :latitude => @latitude, :longitude => @longitude, :mail_id => @mail_id, :notice => @notice
      end

      if @staff.save
        # 参集先情報送信成功時の処理
        @notice = "送信しました"
        redirect_to :action => "destination_form", :agent_id => @agent_id, :latitude => @latitude, :longitude => @longitude, :mail_id => @mail_id, :notice => @notice
      else
        # 参集先情報送信失敗時の処理
        @notice = "参集先情報の送信に失敗しました"
        redirect_to :action => "destination_form", :agent_id => @agent_id, :latitude => @latitude, :longitude => @longitude, :mail_id => @mail_id, :notice => @notice
      end

    else
      # 参集先情報送信失敗時の処理
      @notice = "参集場所を選択してください"
      redirect_to :action => "destination_form", :agent_id => @agent_id, :latitude => @latitude, :longitude => @longitude, :mail_id => @mail_id, :notice => @notice
    end

  end

  # 職員参集場所確認画面
  # 初期処理
  # ==== Args
  # ==== Return
  # ==== Raise
  def index
    @shelters = Shelter.find(:all)
    new = Staff.maximum(:mail_id) # 最新の災害番号データ
    @staffs = Staff.find(:all, :conditions => { :mail_id => new })
    @zoom = 15
    @shelters.each_with_index do |shelter, count|
      lat = shelter.latitude - LATITUDE
      lng = shelter.longitude - LONGITUDE
      diff = Math::sqrt(lat * lat + lng * lng)
      @zoom = Math::log(534.0/diff)/Math::log(2) < @zoom ? Math::log(534.0/diff)/Math::log(2) : @zoom
    end
    @zoom = @zoom.round - 1
  end
end

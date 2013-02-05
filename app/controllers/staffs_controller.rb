# -*- coding:utf-8 -*-
# Staff Finderの処理を行うクラス
class StaffsController < ApplicationController

  before_filter :authenticate_user!, :only => 'index'

  skip_before_filter :check_if_login_required, :except => :index

  layout :layout_selector

  trans_sid

  # レイアウトの選択処理
  # 各画面で使用するレイアウトを決定する
  # ==== Args
  # _params[:action]_ :: URL（パス）
  # ==== Return
  # レイアウト名
  # ==== Raise
  def layout_selector
    case params[:action]
    when 'mail'
      'lgdsf'
    when 'index'
      'lgdsf_index'
    when 'position_form'
      request.mobile? ? 'lgdsf_mobile' : 'lgdsf_smartphone_position'
    when 'destination_form'
      request.mobile? ? 'lgdsf_mobile' : 'lgdsf_smartphone_map'
    else
      request.mobile? ? 'lgdsf_mobile' : 'lgdsf_smartphone'
    end
  end

  # 災害メール
  # 読み込み処理
  # ==== Args
  # ==== Return
  # ==== Raise
  def mail
    # TODO：動作確認用メソッド（結合時には削除する）
  end

  # 個人特定情報送信画面
  # 読み込み処理
  # モバイルの場合は、モバイル用のviewに切替える
  # ==== Args
  # _params[:mail_id]_ :: 災害番号
  # ==== Return
  # ==== Raise
  def send_form
    @mail_id = params[:mail_id]
    # モバイルの場合は、モバイル用のviewに切替える
    if request.mobile?
      render "send_form_mobile"
    else
      render
    end
  end

  # 個人特定情報送信画面
  # 書き込み処理
  # 入力されたメールアドレスを元に認証を行う
  # * 認証が成功した場合、職員の名前とID、災害番号をDBに登録し、位置情報送信画面に遷移する
  # * 認証が失敗した場合、"認証に失敗しました"と画面上部に表示する。
  # ==== Args
  # _params[:mail]_ :: メールアドレス
  # _params[:mail_id]_ :: 災害番号
  # ==== Return
  # ==== Raise
  def save_send
    @notice = nil
    mail = params[:mail]['mail_address']
    @mail_id = params[:mail_id]

    # メールアドレス認証
    if mail.present?

      # メールアドレスの入力可能数が256桁である。
      if mail.size <= 256

        # TODO：LDAP認証で行う
        @agent = Agent.find_by_mail_address(mail)

        if @agent.present?
          # 認証成功の場合
          @staff = Staff.find_by_agent_id_and_mail_id(@agent.id, @mail_id)
    
          if @staff.present?
            # 上書き
            @staff.name = @agent.name
            @staff.agent_id = @agent.id
          else
            # 挿入
            @staff = Staff.new(:name => @agent.name, :agent_id => @agent.id, :mail_id => @mail_id)
          end
    
          # DB登録処理
          if @staff.save
            redirect_to :action  =>"position_form", :mail_id => @mail_id, :agent_id => @agent.id
            return false
          else
            @notice = "DBの登録に失敗しました"
          end
      
        else
          @notice = "認証に失敗しました"
        end
      else
        @notice = "メールアドレスは256桁以下で入力してください"
      end
    else
      @notice = "メールアドレスを入力してください"
    end

    # エラーの場合
    if @notice.present?
      redirect_to :action => 'send_form', :mail_id => @mail_id, :notice => @notice
    end

  end

  # 位置情報送信画面
  # 読み込み処理
  # モバイルの場合は、モバイル用のviewに切替える
  # ==== Args
  # _params[:mail_id]_ :: 災害番号
  # _params[:agent_id]_ :: 職員ID
  # ==== Return
  # ==== Raise
  def position_form
    @mail_id = params[:mail_id]
    @agent_id = params[:agent_id]
    # モバイルの場合は、モバイル用のviewに切替える
    if request.mobile?
      render "position_form_mobile"
    else
      render
    end
  end

  # 位置情報送信画面
  # 書き込み処理
  # 端末の位置情報を取得し、DBに保存する。
  # * 現在位置送信が成功した場合、位置情報（緯度、経度）をDBに登録し、参集場所報告画面に遷移する
  # * 現在位置送信が失敗した場合、"現在位置の送信に失敗しました"と画面上部に表示する。
  # ==== Args
  # _params[:mail_id]_ :: 災害番号
  # _params[:agent_id]_ :: 職員ID
  # ==== Return
  # ==== Raise
  def save_position
    @notice = nil
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

    # 現在位置の取得成功の場合
    if @latitude.present? && @longitude.present?

      @staff = Staff.find_by_agent_id_and_mail_id(@agent_id, @mail_id)

      if @staff.present?
        # 上書き
        @staff.latitude = @latitude
        @staff.longitude = @longitude
      else
        # 挿入
        @agent = Agent.find_by_id(@agent_id)
        @staff = Staff.new(:name => @agent.name, :agent_id => @agent_id, :latitude => @latitude, :longitude => @longitude, :mail_id => @mail_id)
      end

      # DB登録処理
      if @staff.save
        # 現在位置送信成功時の場合
        redirect_to :action => "destination_form", :agent_id => @agent_id, :latitude => @latitude, :longitude => @longitude, :mail_id => @mail_id
        return false
      else
        # 現在位置送信失敗時の場合
        @notice = "現在位置の送信に失敗しました"
      end
    else
      # 現在位置取得失敗時の場合
      @notice = "現在位置の取得に失敗しました"
    end

    # エラーの場合
    if @notice.present?
      redirect_to :action => 'position_form', :mail_id => @mail_id, :agent_id => @agent_id, :notice => @notice
    end
  end

  # 参集場所報告画面
  # 読み込み処理
  # 近くの参集場所を計算して求め、所定の参集場所と近くの参集場所をGoogle Map上に表示する。
  # ==== Args
  # _params[:mail_id]_ :: 災害番号
  # _params[:agent_id]_ :: 職員ID
  # _params[:latitude]_ :: 緯度
  # _params[:longitude]_ :: 経度
  # ==== Return
  # ==== Raise
  def destination_form
    @mail_id = params[:mail_id]
    @agent_id = params[:agent_id]
    @latitude = params[:latitude].to_f
    @longitude = params[:longitude].to_f
    @zoom = 13

    # 近くの参集場所の計算
    diffs = []
    size = request.mobile? ? 200.0 : 350.0

    # 2点間の距離を求める
    @gathering_positions.each do |id, gathering_position|
      count = id.to_i-1
      lat = gathering_position["latitude"].to_f - @latitude
      lng = gathering_position["longitude"].to_f - @longitude
      diffs[count] = Math::sqrt(lat * lat + lng * lng)
      @zoom = Math::log(size/diffs[count])/Math::log(2) < @zoom ? Math::log(size/diffs[count])/Math::log(2) : @zoom
    end

    temps = []
    temps = diffs.sort

    # ズームの微調整
    @zoom = @zoom.round - 1

    # 所定の参集場所の取得
    @predefined_position = @predefined_positions["#{@agent_id}"]["position_code"].to_i

    # id は配列の番号なので実際には+1した値がID
    # 所定の参集場所IDを初期値として代入しておく。
    gathering_position_ids = []

    # モバイル・スマートフォンにより、近くの参集場所の表示数を分ける
    roop = request.mobile? ? 3 : 8

    # 参集場所を近い順に並べる
    i = 0
    while i < roop
      diffs.each_with_index do |diff, count|
        if temps[i] == diff
          if @predefined_position != (count + 1)
            gathering_position_ids.push(count + 1)
            break
          else
            roop += 1
            break
          end
        end
      end
      i += 1
    end

    # 近くの参集場所を@near_gathering_positions変数に格納する。
    @near_gathering_positions = {}
    gathering_position_ids.each do |gathering_position_id|
      @near_gathering_positions[gathering_position_id] = @gathering_positions["#{gathering_position_id}"]
    end

    # モバイルの場合は、モバイル用のviewに切替える
    if request.mobile?
      render "destination_form_mobile"
    else
      render
    end
  end

  # 参集場所報告画面
  # 書き込み処理
  # 職員の参集先情報を取得し、DBに保存する。
  # * 参集先情報送信が成功した場合、参集先情報をDBに登録し、"送信しました"と画面上部に表示する。
  # * 参集先情報送信が失敗した場合、"参集先情報の送信に失敗しました"と画面上部に表示する。
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

    # バリデーションチェック
    if @destination['position'].present? || @destination['place'].to_i == 1 

      @staff = Staff.find_by_agent_id_and_mail_id(@agent_id, @mail_id)

      if @staff.present?
        # 上書き
        if @destination['place'].to_i == 1
          @staff.status = false
          @staff.destination = ''
          @staff.reason = @destination['reason'].present? ? @destination['reason'] : ''
        else
          @staff.status = true
          gathering_position = @gathering_positions[@destination['position']]
          @staff.destination = gathering_position['name']
          @staff.reason = ''
        end
      else
        # 挿入（エラー処理）
        @notice = "参集先情報の送信に失敗しました"
      end

      # DB登録処理
      if @staff.save
        # 参集先情報送信成功時の処理
        @notice = "送信しました"
      else
        # 参集先情報送信失敗時の処理
        @notice = "参集先情報の送信に失敗しました"
      end

    else
      # 参集先情報送信失敗時の処理
      @notice = "参集場所を選択してください"
    end

    if @notice.present?
      redirect_to :action => "destination_form", :agent_id => @agent_id, :latitude => @latitude, :longitude => @longitude, :mail_id => @mail_id, :notice => @notice
    end
  end

  # 職員位置確認画面
  # 初期処理
  # 最新の災害の職員の参集先情報をGoogle Map上に表示する。
  # ==== Args
  # ==== Return
  # ==== Raise
  def index
    # ActiveResource各種設定
    settings   = YAML.load_file("#{Rails.root}/config/settings.yml")

    # 職員位置確認画面のマップの中心緯度
    @latitude  = settings["ldgsf"][Rails.env]["latitude"]

    # 職員位置確認画面のマップの中心経度
    @longitude = settings["ldgsf"][Rails.env]["longitude"]

    # 最新の災害番号データの取得
    new_mail_id = Staff.maximum(:mail_id)
    @staffs = Staff.all(:conditions => { :mail_id => new_mail_id })

    # 2点間の距離を求め、ズーム率を決定する。
    @zoom = 13
    @gathering_positions.each do |id, gathering_position|
      lat = gathering_position["latitude"].to_f - @latitude
      lng = gathering_position["longitude"].to_f - @longitude
      count = id.to_i-1
      diff = Math::sqrt(lat * lat + lng * lng)
      @zoom = Math::log(534.0/diff)/Math::log(2) < @zoom ? Math::log(534.0/diff)/Math::log(2) : @zoom
    end
    @zoom = @zoom.round - 1
  end
end

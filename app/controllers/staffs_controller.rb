# encoding: utf-8
class StaffsController < ApplicationController
  before_filter :authenticate_user!, :only => 'index'

  skip_before_filter :check_if_login_required, :except => :index

  layout :layout_selector

  trans_sid

  def layout_selector
    case params[:action]
    when 'mail'
      'lgdsf'
    when 'index'
      'lgdsf_redmine'
    when 'destination_form'
      request.mobile? ? 'lgdsf_mobile' : 'lgdsf_smartphone_map'
    else
      request.mobile? ? 'lgdsf_mobile' : 'lgdsf_smartphone'
    end
  end

  def mail
  end

  def send_form
    @mail_id = params[:mail_id]
    if request.mobile?
      render "send_form_mobile"
    else
      render
    end
  end

  def save_send
    @mail = params[:mail]
    @agent = Agent.find_by_mail_address(@mail['mail_address'])

    # メールアドレス認証
    if @agent.present?
      @agent_id = @agent.id
      redirect_to :controller =>"staffs", :action  =>"position_form", :mail => @mail, :agent_id => @agent_id
    else
      # メールアドレス認証失敗時の処理
      #render text: "認証に失敗しました"
    end
  end

  def position_form
    @shelters = Shelter.find(:all)
    @agent_id = params[:agent_id]

    if request.mobile?
      render "position_form_mobile"
    else
      render
    end
  end

  def save_position
    #@latitude = params[:latitude]
    #@longitude = params[:longitude]

    #if request.mobile? and request.mobile.position
    #  @latitude = request.mobile.position.lat
    #  @longitude = request.mobile.position.lon
    #end

    #p "**********"
    #p @latitude
    #p "**********"
    #p "++++++++++"
    #p @longitude
    #p "++++++++++"

    # 職員ID、現在位置が取得できていないので定数を代入
    @agent_id = 1
    @latitude  = 38.4344802
    @longitude = 141.3029167

    if @latitude.present? && @longitude.present?
      # 現在位置送信成功時の処理
      redirect_to :action => "destination_form", :agent_id => @agent_id, :latitude => @latitude, :longitude => @longitude
    else
      # 現在位置取得失敗時の処理
      #render text: "現在位置の送信に失敗しました"
    end

  end

  def destination_form
    @all_shelters = Shelter.find(:all)
    @agent_id = params[:agent_id]
    @latitude = params[:latitude].to_f
    @longitude = params[:longitude].to_f
    @zoom = 15

    # 参集場所の取得
    place = PredefinedPosition.find(@agent_id)
    @predefinedposition = Shelter.find(place.shelter_id)

    # 近くの参集場所の計算
    diffs = []
    size = request.mobile? ? 240.0 : 350.0

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

    # id は配列の番号なので実際には+1した値がID
    # 所定の参集場所IDを初期値として代入しておく。
    shelters_id = []
    shelters_id.push(@predefinedposition.id)

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

  def save_destination
    @destination = params[:destination]
  
    p "----------"
    p @destination
    p "----------"

    redirect_to :action => "mail"
  end

  def index
    @shelters = Shelter.find(:all)
    @staffs   = Staff.find(:all)
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

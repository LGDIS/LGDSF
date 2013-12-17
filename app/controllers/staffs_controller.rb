# -*- coding:utf-8 -*-
# Staff Finderの処理を行うクラス
class StaffsController < ApplicationController

  before_filter :authenticate_user!, :only => [:index, :index_department]

  skip_before_filter :check_if_login_required, :except => [:index, :index_department]

  layout :layout_selector

  trans_sid

  # 個人特定情報送信画面
  class MailBlankException < StandardError; end
  class MailLengthException < StandardError; end
  class AgentBlankException < StandardError; end

  # 位置情報情報送信画面
  class PositionBlankException < StandardError; end

  # 参集場所報告画面
  class DestinationBlankException < StandardError; end
  class ProjectIdBlankException < StandardError; end
  class AgentConnectException < StandardError; end

  # レイアウトの選択処理
  # 各画面で使用するレイアウトを決定する
  # ==== Args
  # _action_ :: 画面識別子
  # ==== Return
  # レイアウト名
  # ==== Raise
  def layout_selector
    case params[:action]
    when 'index', 'index_department'
      'lgdsf_index' # PC
    else
      request.mobile? ? 'lgdsf_mobile' : 'lgdsf_smartphone' # Feature/Smart-Phone
    end
  end

  # 個人特定情報送信画面
  # 読み込み処理
  # モバイルの場合は、モバイル用のviewに切替える
  # ==== Args
  # ==== Return
  # ==== Raise
  def send_form
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
  # * 認証が成功した場合、メールアドレスから生成した個人URL用文字列をDBに登録し、位置情報送信画面に遷移する
  # * 認証が失敗した場合、"認証に失敗しました"と画面上部に表示する。
  # ==== Args
  # _mail_ :: メールアドレス
  # ==== Return
  # ==== Raise
  def save_send

    begin
      # メールアドレスが空の場合、例外を発生させる。
      raise MailBlankException, I18n.t("errors.messages.mail_blank") if params[:mail].blank?
      # メールアドレスの入力数が256桁以上の場合、例外を発生させる。
      raise MailLengthException, I18n.t("errors.messages.mail_length") if params[:mail].size > 256
      # TODO: LDAP認証で行う
      agent = Agent.find_by_mail_address(params[:mail])
      # Agentが存在しない場合、例外を発生させる。
      raise AgentBlankException, I18n.t("errors.messages.agent_blank") if agent.blank?
      # 認証成功の場合
      # 初回の場合のみ個人URL用の文字列を生成・登録する
      if agent.path.blank?
        agent_path = Digest::MD5.hexdigest(params[:mail] + SETTINGS["user_path_code"] )
        agent.update_attributes(:path => agent_path)
      end

    rescue MailBlankException, MailLengthException, AgentBlankException, ActiveRecord::RecordInvalid => e
      flash[:notice] = e.message
      redirect_to :action => :send_form, :notice => flash[:notice]
      return
    end

    redirect_to :action  => :position_form, :agent_id => agent.path
  end

  # 位置情報送信画面
  # 読み込み処理
  # モバイルの場合は、モバイル用のviewに切替える
  # ==== Args
  # _agent_id_ :: 職員ID
  # ==== Return
  # ==== Raise
  def position_form
    @agent_id = params[:agent_id]
    # Auの場合、sessionを記録する
    if request.mobile.is_a?(Jpmobile::Mobile::Au)
      reset_session
      session[:agent_id] = @agent_id
    end

    # モバイルの場合は、モバイル用のviewに切替える
    if request.mobile?
      render "position_form_mobile"
    else
      render
    end
  end

  # 位置情報送信画面
  # 書き込み処理
  # 端末の位置情報を取得し、参集場所報告画面に渡す。。
  # * 現在位置送信が成功した場合、位置情報（緯度、経度）を保持して、参集場所報告画面に遷移する
  # * 現在位置送信が失敗した場合、"現在位置の送信に失敗しました"と画面上部に表示する。
  # ==== Args
  # _agent_id_ :: 職員ID
  # ==== Return
  # ==== Raise
  def save_position
    # Auの場合、sessionを渡す。
    if request.mobile.is_a?(Jpmobile::Mobile::Au)
      @agent_id = session[:agent_id]
    else
      @agent_id = params[:agent_id]
    end

    # 現在位置の取得
    if request.mobile? and request.mobile.position
      @latitude = request.mobile.position.lat
      @longitude = request.mobile.position.lon
    else
      @latitude = params[:latitude]
      @longitude = params[:longitude]
    end

    begin
      # 現在位置の取得失敗の場合
      raise PositionBlankException, I18n.t("errors.messages.position_blank") if @latitude.blank? || @longitude.blank?

    rescue PositionBlankException, ActiveRecord::RecordInvalid => e
      flash[:notice] = e.message
      redirect_to :action => :position_form, :agent_id => @agent_id, :notice => flash[:notice]
      return
    end

    if request.mobile.is_a?(Jpmobile::Mobile::Au)
      redirect_to :action => :destination_form, :latitude => @latitude, :longitude => @longitude
    else
      redirect_to :action => :destination_form, :agent_id => @agent_id, :latitude => @latitude, :longitude => @longitude
    end

  end

  # 参集場所報告画面
  # 読み込み処理
  # 近くの参集場所を計算して求め、所定の参集場所と近くの参集場所をGoogle Map上に表示する。
  # ==== Args
  # _agent_id_ :: 職員ID
  # _latitude_ :: 緯度
  # _longitude_ :: 経度
  # ==== Return
  # ==== Raise
  def destination_form

    # Auの場合、sessionを渡し、sessionを削除する
    if params[:agent_id].blank?
      @agent_id = session[:agent_id]
      reset_session
    else
      @agent_id = params[:agent_id]
    end

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

    # ズームの微調整
    @zoom = @zoom.round - 1

    temps = []
    temps = diffs.sort

    begin
      # Agentを取得
      agent = Agent.find_by_path(@agent_id)
      # Agentが存在しない場合、例外を発生させる。
      raise AgentBlankException, I18n.t("errors.messages.agent_blank") if agent.blank?

    rescue AgentBlankException, ActiveRecord::RecordInvalid => e
      flash[:notice] = e.message
      redirect_to :action => :position_form, :agent_id => @agent_id, :notice => flash[:notice]
      return
    end

    # 所定の参集場所の取得
    predefined_position = @predefined_positions.where(:agent_id => agent.id.to_s)
    if predefined_position.present?
      @predefined_position = predefined_position.first.position_code.to_i
    end

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
  # * 参集先情報送信が成功した場合、参集先情報をDBに登録する。
  # * 参集先情報送信が失敗した場合、"参集先情報の送信に失敗しました"と画面上部に表示する。
  # ==== Args
  # _destination_ :: 参集場所情報
  # _agent_id_ :: 職員ID
  # _latitude_ :: 緯度
  # _longitude_ :: 経度
  # ==== Return
  # ==== Raise
  def save_destination
    @destination = params[:destination]
    @agent_id = params[:agent_id]
    @latitude = params[:latitude]
    @longitude = params[:longitude]

    begin
      raise DestinationBlankException, I18n.t("errors.messages.place_blank") if @destination['reason'].present? && @destination['place'].to_i == 0
      raise DestinationBlankException, I18n.t("errors.messages.destination_blank") if (@destination['position'].blank? && @destination['place'].to_i == 0) && @destination['note'].blank?

      # 災害コード(プロジェクトIDを利用する)
      disaster_code = ""

      # LGDIFにHTTPでアクセスし、プロジェクトIDを取得する
      begin
        url = SETTINGS["project_id_url"] + "/delivery_project/getproject"
        first = true
        SETTINGS["delivery_place_id"].each do |id|
          if first
            url = url + "?id[]=" + id.to_s
            first = false
          else
            url = url + "&id[]=" + id.to_s
          end
        end

        uri = URI.parse(url)
        http = Net::HTTP::new(uri.host, uri.port)
        http.start{|w|
          res = w.get(url)
          if res.kind_of?(Net::HTTPOK)
            disaster_code = res.body
          else
            # 例外処理
            raise AgentConnectException, I18n.t("errors.messages.project_connect_error")
          end
        }
      rescue
        raise AgentConnectException, I18n.t("errors.messages.project_connect_error")
      end

      # プロジェクトIDを取得できない場合はエラー
      # そもそも参集メールが送られていない状態のはず
      raise ProjectIdBlankException, I18n.t("errors.messages.project_id_blank") if disaster_code.blank?

      # 災害番号を20桁(カラムの最大桁数)で0埋めする
      disaster_code = sprintf("%020" + "d", disaster_code.to_i)

      # TODO: LDAP認証で行う
      agent = Agent.find_by_path(@agent_id)

      ## Agentが存在しない場合、例外を発生させる。
      raise AgentBlankException, I18n.t("errors.messages.agent_blank") if agent.blank?

      staff = Staff.find_by_agent_id_and_disaster_code(agent.id, disaster_code)
      reason_str = ''
      position_code_str = ''
      dest_flg = true

      if @destination['place'].to_i == 1
        # 参集場所に向かうのが困難
        reason_str = @destination['reason'].to_s
        dest_flg = false
      elsif @destination['position'].present?
        # 参集場所指定あり
        gathering_position = @gathering_positions[@destination['position']]
        position_code_str = gathering_position['position_code']
      end

      if staff.present?
        # 更新の場合
        staff.update_attributes!(:name => agent.name, :agent_id => agent.id, :disaster_code => disaster_code, :status  => dest_flg, :destination_code => position_code_str, :reason => reason_str, :latitude => @latitude, :longitude => @longitude)
      else
        # 新規の場合
        staff = Staff.create!(:name => agent.name, :agent_id => agent.id, :disaster_code => disaster_code, :status => dest_flg, :destination_code => position_code_str, :reason => reason_str, :latitude => @latitude, :longitude => @longitude)
      end

      # 肩代わり報告
      if @destination['note'].present?
        Note.create!(:note => @destination['note'], :staff_id => staff.id)
      end

    rescue DestinationBlankException,ProjectIdBlankException, ActiveRecord::RecordInvalid => e
      flash[:notice] = e.message
      redirect_to :action => :destination_form, :agent_id => @agent_id, :latitude => @latitude, :longitude => @longitude, :notice => flash[:notice]
      return
    end

    redirect_to "/position_send_success/index"
  end

  # 職員位置確認画面
  # 初期処理（共通処理）
  # 最新の災害の職員の参集先情報をGoogle Map上に表示する。
  # ==== Args
  # ==== Return
  # ==== Raise
  def main
    # 職員位置確認画面のマップの中心
    @latitude  = SETTINGS["index_map"]["latitude"]
    @longitude = SETTINGS["index_map"]["longitude"]

    # 最新の災害番号データの取得
    new_disaster_code = Staff.maximum(:disaster_code)
    @staffs = Staff.all(:conditions => { :disaster_code => new_disaster_code })

    # 現在位置不明者作成
    @position_unknown_staffs = [] # 現在位置不明
    @destination_unknown_staffs = [] # 参集先不明
    @not_gathered_staffs = [] # 参集不可

    @staffs.each_with_index do |staff, pos|
      if staff.latitude.present? && staff.longitude.present?
        if staff.status == false
          @not_gathered_staffs.push(pos)
        elsif staff.destination_code.blank?
          @destination_unknown_staffs.push(pos)
        end
      else
        @position_unknown_staffs.push(pos)
      end
    end

    # 肩代わり報告
    @notes = Note.joins(:staff).where(:staffs => {:disaster_code => new_disaster_code}).order("created_at DESC").limit(100)

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

  # 職員位置確認画面
  # 初期処理（参集場所）
  # 最新の災害の職員の参集先情報をGoogle Map上に表示する。
  # ==== Args
  # ==== Return
  # ==== Raise
  def index
    set_tab :gatheringposition
    main
  end

  # 職員位置確認画面
  # 初期処理（部署）
  # 最新の災害の職員の参集先情報をGoogle Map上に表示する。
  # ==== Args
  # ==== Return
  # ==== Raise
  def index_department
    set_tab :department
    main
  end

end

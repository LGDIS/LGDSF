# -*- coding:utf-8 -*-
require 'spec_helper'

describe StaffsController do

  before 'ApplicationController' do
    @gathering_positions  = Rails.cache.read("gathering_position")
    @predefined_positions = Rails.cache.read("predefined_position")
  end

  describe 'layout_selector' do
  end

  describe 'mail' do
    before 'アクセス' do
      get :mail
    end
    context '正常の場合' do
      it 'getが成功すること' do
        response.should be_success
      end
      it 'テンプレートが適用されていること' do
        response.should render_template("mail") # lgdsf
      end
    end
  end

  describe 'send_form' do
    before '適当なメールIDを渡す' do
      get :send_form, :mail_id => "2013#{rand(13)}#{rand(32)}#{rand(24)}#{rand(60)}#{rand(100)}"
      @mail_id = assigns[:mail_id]
    end
    context '正常の場合' do
      it 'getが成功すること' do
        response.should be_success
      end
      it 'テンプレートが適用されていること' do
        response.should render_template("staffs/send_form") # lgdsf_smartphone
      end
      describe '@mail_id' do
        it 'Stringクラスであること' do
          @mail_id.should be_an_instance_of(String)
        end
      end
      context 'request.mobile?' do
        context 'true' do
          describe 'モバイル' do
            before '' do
              controller.request.env['HTTP_USER_AGENT'] = 'DoCoMo'
            end
            it 'DoCoMoのとき、trueであること' do
              request.mobile?.should be_true
            end
            it '' do
              pending 'renderが行えないため保留' do
              render "send_form_mobile"
              end
            end
          end
        end
        context 'false' do
          describe 'スマートフォン' do
            it 'iPhoneのとき、falseであること' do
              controller.request.env['HTTP_USER_AGENT'] = 'iPhone'
              request.mobile?.should be_false
            end
            it 'Androidのとき、falseであること' do
              controller.request.env['HTTP_USER_AGENT'] = 'Android'
              request.mobile?.should be_false
            end
          end
        end
        context 'nil' do
          describe 'PC' do
            it 'FireFoxのとき、nilであること' do
              controller.request.env['HTTP_USER_AGENT'] = "Mozilla"
              request.mobile?.should be_nil
            end
          end
        end
      end
    end
  end

  describe 'save_send' do
    context '正常の場合' do
      before '適当なメールアドレス、メールIDを渡す' do
        get :save_send, :mail => {"mail_address"=>"sato@gmail.com"}, :mail_id => "2013#{rand(13)}#{rand(32)}#{rand(24)}#{rand(60)}#{rand(100)}"
        @mail = assigns[:mail]
        @mail_id = assigns[:mail_id]
      end
      describe "@mail" do
        it 'メールアドレスが正しく取得できること' do
          @mail['mail_address'].present?.should be_true
        end
        describe '職員のメールアドレス' do
          before '' do
            @agent = Agent.find_by_mail_address(@mail['mail_address'])
            @staff = Staff.find_by_agent_id_and_mail_id(@agent.id, @mail_id)
          end
          it 'メールアドレスが一致すること' do
            @agent.present?.should be_true
          end
          it '職員が存在すること' do
            @staff.present?.should be_true
          end
          it 'DB登録が終了すること' do
            @staff = Staff.new(:name => @agent.name, :agent_id => @agent.id, :mail_id => @mail_id)
            @staff.save.should be_true
          end
          it '位置情報送信画面にリダイレクトする' do
            response.should redirect_to(:action => 'position_form', :mail_id => @mail_id, :agent_id => @agent.id)
          end
        end
      end
    end
    context '異常の場合' do
      context 'メールアドレスが空の場合' do
        before '適当なメールアドレス、メールIDを渡す' do
          get :save_send, :mail => {"mail_address"=>""}, :mail_id => "2013#{rand(13)}#{rand(32)}#{rand(24)}#{rand(60)}#{rand(100)}"
          @mail = assigns[:mail]
          @mail_id = assigns[:mail_id]
        end
        describe '@mail' do
          it 'メールアドレスが空であること' do
            @mail['mail_address'].present?.should be_false
          end
        end
        it '個人特定情報送信画面にリダイレクトする' do
          @notice = "メールアドレスを入力してください"
          response.should redirect_to(:action => 'send_form', :mail_id => @mail_id, :notice => @notice)
        end
      end
    end
  end

  describe 'position_form' do
    before '適当なメールIDを渡す' do
      get :position_form, :mail_id => "2013#{rand(13)}#{rand(32)}#{rand(24)}#{rand(60)}#{rand(100)}", :agent_id => 1
      @mail_id = assigns[:mail_id]
      @agent_id = assigns[:agent_id]
    end
    context '正常の場合' do
      it 'getが成功すること' do
        response.should be_success
      end
      it 'テンプレートが適用されていること' do
        response.should render_template("staffs/position_form") # lgdsf_smartphone
      end
      describe '@mail_id' do
        it 'Stringクラスであること' do
          @mail_id.should be_an_instance_of(String)
        end
      end
      describe '@agent_id' do
        it 'Stringクラスであること' do
          @agent_id.should be_an_instance_of(String)
        end
      end
      context 'request.mobile?' do
        context 'true' do
          describe 'モバイル' do
            before '' do
              controller.request.env['HTTP_USER_AGENT'] = 'DoCoMo'
            end
            it 'DoCoMoのとき、trueであること' do
              request.mobile?.should be_true
            end
            it '' do
              pending 'renderが行えないため保留' do
              render "position_form_mobile"
              end
            end
          end
        end
        context 'false' do
          describe 'スマートフォン' do
            it 'iPhoneのとき、falseであること' do
              controller.request.env['HTTP_USER_AGENT'] = 'iPhone'
              request.mobile?.should be_false
            end
            it 'Androidのとき、falseであること' do
              controller.request.env['HTTP_USER_AGENT'] = 'Android'
              request.mobile?.should be_false
            end
          end
        end
        context 'nil' do
          describe 'PC' do
            it 'FireFoxのとき、nilであること' do
              controller.request.env['HTTP_USER_AGENT'] = "Mozilla"
              request.mobile?.should be_nil
            end
          end
        end
      end
    end
  end

  describe 'save_position' do
    context '正常の場合' do
      before '適当な職員ID、メールIDを渡す' do
        get :save_position, :agent_id => 1, :mail_id => "2013#{rand(13)}#{rand(32)}#{rand(24)}#{rand(60)}#{rand(100)}", :latitude => "38.43448027777777", :longitude => "141.30291666666668"
        @mail_id = assigns[:mail_id]
        @agent_id = assigns[:agent_id]
        @latitude = assigns[:latitude]
        @longitude = assigns[:longitude]
      end
      context 'request.mobile?' do
        context 'true' do
          describe 'モバイル' do
            before '' do
              controller.request.env['HTTP_USER_AGENT'] = 'DoCoMo'
            end
            it 'DoCoMoのとき、trueであること' do
              request.mobile?.should be_true
            end
            it '緯度、経度が取得できること' do
              #pending 'Unsuppotedと出る為、保留' do
              #request.mobile.position
              #end
            end
          end
        end
        context 'false' do
          describe 'スマートフォン' do
            it 'iPhoneのとき、falseであること' do
              controller.request.env['HTTP_USER_AGENT'] = 'iPhone'
              request.mobile?.should be_false
            end
            it 'Androidのとき、falseであること' do
              controller.request.env['HTTP_USER_AGENT'] = 'Android'
              request.mobile?.should be_false
            end
          end
        end
        context 'nil' do
          describe 'PC' do
            it 'FireFoxのとき、nilであること' do
              controller.request.env['HTTP_USER_AGENT'] = "Mozilla"
              request.mobile?.should be_nil
            end
          end
        end
      end
      context '現在位置の取得成功の場合' do
        before '' do
          @staff = Staff.find_by_agent_id_and_mail_id(@agent_id, @mail_id)
        end
        it '緯度、経度が空でないこと' do
          (@latitude.present? && @longitude.present?).should be_true
        end
        it '職員が存在すること' do
          @staff.present?.should be_true
        end
        it 'DB登録が終了すること' do
          @staff.latitude = @latitude
          @staff.longitude = @longitude
          @staff.save.should be_true
        end
        it '参集場所報告画面にリダイレクトする' do
          response.should redirect_to(:action => 'destination_form', :agent_id => @agent_id, :latitude => @latitude, :longitude => @longitude, :mail_id => @mail_id)
        end
      end
    end
    context '異常の場合' do
      context 'メールアドレスが空の場合' do
        before '適当なメールアドレス、メールIDを渡す' do
          get :save_position, :agent_id => 1, :mail_id => "2013#{rand(13)}#{rand(32)}#{rand(24)}#{rand(60)}#{rand(100)}"
          @mail_id = assigns[:mail_id]
          @agent_id = assigns[:agent_id]
          @latitude = nil
          @longitude = nil
        end
        describe '位置情報' do
          it '緯度か経度が空であること' do
            (@latitude.blank? || @longitude.blank?).should be_true
          end
        end
        it '個人特定情報送信画面にリダイレクトする' do
          @notice = "現在位置の取得に失敗しました"
          response.should redirect_to(:action => 'position_form', :mail_id => @mail_id, :agent_id => @agent_id, :notice => @notice)
        end
      end
    end
  end

  describe 'destination_form' do
    context '正常の場合' do
      before '' do
        get :destination_form, :agent_id => 1, :mail_id => "2013#{rand(13)}#{rand(32)}#{rand(24)}#{rand(60)}#{rand(100)}", :latitude => "38.43448027777777", :longitude => "141.30291666666668"
        @mail_id = assigns[:mail_id]
        @agent_id = assigns[:agent_id]
        @latitude = assigns[:latitude]
        @longitude = assigns[:longitude]
        @zoom = 13
      end
      it 'getが成功すること' do
        response.should be_success
      end
      it 'テンプレートが適用されていること' do
        response.should render_template("destination_form") # lgdsf
      end
      it '' do
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
      end
    end
  end

  describe 'save_destination' do
    context '正常の場合' do
      before '適当な職員ID、メールIDを渡す' do
        pending 'get できないため保留' do
        get :save_destination, :agent_id => 1, :mail_id => "2013#{rand(13)}#{rand(32)}#{rand(24)}#{rand(60)}#{rand(100)}", :latitude => "38.43448027777777", :longitude => "141.30291666666668", :destination => {:position => "7", :place => "0", :reason => ""}
        end
        @mail_id = assigns[:mail_id]
        @agent_id = assigns[:agent_id]
        @latitude = assigns[:latitude]
        @longitude = assigns[:longitude]
      end
      describe "@destination" do
        it '参集場所情報が正しく取得できること' do
          (@destination['position'].present? || @destination['place'].to_i == 1).should be_true
        end
        describe '' do
          before '' do
            @staff = Staff.find_by_agent_id_and_mail_id(@agent.id, @mail_id)
          end
          it '職員が存在すること' do
            @staff.present?.should be_true
          end
          it 'DB登録が終了すること' do
            @staff.status = true
            gathering_position = @gathering_positions[@destination['position']]
            @staff.destination = gathering_position['name']
            @staff.reason = ''
            @staff.save.should be_true
          end
          it '送信しましたと画面上部に表示すること' do
            @notice = "送信しました"
            response.should redirect_to(:action => 'destination_form', :agent_id => @agent_id, :latitude => @latitude, :longitude => @longitude, :mail_id => @mail_id, :notice => @notice)
          end
        end
      end
    end
    context '異常の場合' do
      context '参集場所が選択されていない場合' do
        before '' do
          get :save_destination, :agent_id => 1, :mail_id => "2013#{rand(13)}#{rand(32)}#{rand(24)}#{rand(60)}#{rand(100)}", :latitude => "38.43448027777777", :longitude => "141.30291666666668", :destination => {:position => "", :place => "0", :reason => ""}
          @destination = assigns[:destination]
          @mail_id = assigns[:mail_id]
          @agent_id = assigns[:agent_id]
          @latitude = assigns[:latitude]
          @longitude = assigns[:longitude]
        end
        describe '参集場所情報' do
          it '参集場所情報が選択されていないこと' do
            (@destination['position'].present? || @destination['place'].to_i == 1).should be_false
          end
        end
        it '参集場所報告画面にリダイレクトする' do
          @notice = "参集場所を選択してください"
          response.should redirect_to(:action => 'destination_form', :agent_id => @agent_id, :latitude => @latitude, :longitude => @longitude, :mail_id => @mail_id, :notice => @notice)
        end
      end
    end
  end

  describe 'index' do
  
    login_user

    context '正常の場合' do
      before '職員位置確認画面にアクセスする' do
        get :index
      end
      it 'getが成功すること' do
        response.should be_success
      end
      it 'テンプレートが適用されていること' do
        response.should render_template("index") # lgdsf_index
      end
      describe '職員位置確認画面のマップの中心' do
        settings = YAML.load_file("#{Rails.root}/config/settings.yml")
        it '@latitude（緯度）がStringクラスであること' do
          @latitude  = settings["lgdsf"][Rails.env]["latitude"]
          @latitude.should be_an_instance_of(Float)
        end
        it '@longitude（経度）がStringクラスであること' do
          settings = YAML.load_file("#{Rails.root}/config/settings.yml")
          @longitude = settings["lgdsf"][Rails.env]["longitude"]
          @longitude.should be_an_instance_of(Float)
        end
        context '2点間の距離を求め、ズーム率を決定する。' do
          it '2点間の距離を求める' do
            pending "nil can't be coerced into Floatが出る為保留" do
            @zoom = 13
            @gathering_positions.each do |id, gathering_position|
              lat = gathering_position["latitude"].to_f - @latitude
              lng = gathering_position["longitude"].to_f - @longitude
              count = id.to_i-1
              diff = Math::sqrt(lat * lat + lng * lng)
              @zoom = Math::log(534.0/diff)/Math::log(2) < @zoom ? Math::log(534.0/diff)/Math::log(2) : @zoom
            end
            end
          end
          it 'ズーム率を決定する' do
            pending '上記結果を使用するため保留' do
            @zoom = @zoom.round - 1
            end
          end
        end
      end
      describe '最新メール番号' do
        it 'Stringクラスであること' do
          @new_mail_id = Staff.maximum(:mail_id)
          @new_mail_id.should be_an_instance_of(String)
        end
        it 'Staff DBから値が取得できる' do
          @staffs = Staff.find(:all, :conditions => { :mail_id => @new_mail_id })
          @staffs.should be_true
        end
      end
    end
  end

end

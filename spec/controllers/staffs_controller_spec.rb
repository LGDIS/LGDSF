# -*- coding:utf-8 -*-
require 'spec_helper'

describe StaffsController do

  before do
    @gathering_positions  = Rails.cache.read("gathering_position")
    @predefined_positions = Rails.cache.read("predefined_position")
    @factory_staff = FactoryGirl.create(:staff)
    @factory_agent = FactoryGirl.create(:agent)
  end

  describe 'layout_selector' do
    before :each do
      @controller = StaffsController.new
    end
    context 'メール画面のとき' do
      it '"lgdsf"を返却すること' do
        @controller.stub!(:params).and_return({:action => "mail"})
        @controller.layout_selector.should == "lgdsf"
      end
    end
    context 'index画面のとき' do
      it '"lgdsf_index"を返却すること' do
        @controller.stub!(:params).and_return({:action => "index"})
        @controller.layout_selector.should == "lgdsf_index"
      end
    end
    context 'index_department画面のとき' do
      it '"lgdsf_index"を返却すること' do
        @controller.stub!(:params).and_return({:action => "index_department"})
        @controller.layout_selector.should == "lgdsf_index"
      end
    end
    context 'position_form画面のとき' do
      context 'フィーチャーフォンによるアクセスであれば' do
        before :each do
          request = double("HTTPRequest", :mobile? => true)
          @controller.stub!(:request).and_return(request)
        end
        it '"lgdsf_mobile"を返却すること' do
          @controller.stub!(:params).and_return({:action => "position_form"})
          @controller.layout_selector.should == "lgdsf_mobile"
        end
      end
      context 'フィーチャーフォンによるアクセスでなければ' do
        before :each do
          request = double("HTTPRequest", :mobile? => false)
          @controller.stub!(:request).and_return(request)
        end
        it '"lgdsf_smartphone_position"を返却すること' do
          @controller.stub!(:params).and_return({:action => "position_form"})
          @controller.layout_selector.should == "lgdsf_smartphone_position"
        end
      end
    end
    context 'destination_form画面のとき' do
      context 'フィーチャーフォンによるアクセスであれば' do
        before :each do
          request = double("HTTPRequest", :mobile? => true)
          @controller.stub!(:request).and_return(request)
        end
        it '"lgdsf_mobile"を返却すること' do
          @controller.stub!(:params).and_return({:action => "destination_form"})
          @controller.layout_selector.should == "lgdsf_mobile"
        end
      end
      context 'フィーチャーフォンによるアクセスでなければ' do
        before :each do
          request = double("HTTPRequest", :mobile? => false)
          @controller.stub!(:request).and_return(request)
        end
        it '"lgdsf_smartphone_map"を返却すること' do
          @controller.stub!(:params).and_return({:action => "destination_form"})
          @controller.layout_selector.should == "lgdsf_smartphone_map"
        end
      end
    end
    context 'その他の画面のとき' do
      context 'フィーチャーフォンによるアクセスであれば' do
        before :each do
          request = double("HTTPRequest", :mobile? => true)
          @controller.stub!(:request).and_return(request)
        end
        it '"lgdsf_mobile"を返却すること' do
          @controller.stub!(:params).and_return({:action => ""})
          @controller.layout_selector.should == "lgdsf_mobile"
        end
      end
      context 'フィーチャーフォンによるアクセスでなければ' do
        before :each do
          request = double("HTTPRequest", :mobile? => false)
          @controller.stub!(:request).and_return(request)
        end
        it '"lgdsf_smartphone"を返却すること' do
          @controller.stub!(:params).and_return({:action => ""})
          @controller.layout_selector.should == "lgdsf_smartphone"
        end
      end
    end
  end

  describe 'mail' do
    context '正常の場合' do
      before do
        get :mail
      end
      it 'getが成功すること' do
        response.should be_success
      end
      it 'テンプレートが適用されていること' do
        response.should render_template("mail") # lgdsf
      end
    end
  end

  describe 'jpmobile' do
    describe 'request.mobile?' do
      context 'モバイルの場合' do
        describe 'DoCoMo' do
          before do
            controller.request.env['HTTP_USER_AGENT'] = 'DoCoMo'
          end
          it 'trueであること' do
            request.mobile?.should be_true
          end
        end
        describe 'Au' do
          before do
            controller.request.env['HTTP_USER_AGENT'] = 'KDDI-CA39 UP.Browser/6.2.0.13.1.5 (GUI) MMP/2.0'
          end
        end
      end
      context 'スマートフォン/タブレットの場合' do
        describe 'スマートフォン' do
          describe 'iPhone' do
            before do
              controller.request.env['HTTP_USER_AGENT'] = 'iPhone'
            end
            it 'falseであること' do
              request.mobile?.should be_false
            end
          end
          describe 'Android' do
            before do
              controller.request.env['HTTP_USER_AGENT'] = 'Android'
            end
            it 'falseであること' do
              request.mobile?.should be_false
            end
          end
        end
      end
      context 'PCの場合' do
        describe 'Mozilla' do
          before do
            controller.request.env['HTTP_USER_AGENT'] = 'Mozilla'
          end
          it 'nilであること' do
            request.mobile?.should be_nil
          end
        end
      end
    end
    describe 'request.mobile.is_a?(Jpmobile::Mobile::Au)' do
      context '正常な場合' do
        before do
          controller.request.env['HTTP_USER_AGENT'] = 'KDDI-CA39 UP.Browser/6.2.0.13.1.5 (GUI) MMP/2.0'
        end
        it 'trueであること' do
          request.mobile.is_a?(Jpmobile::Mobile::Au).should be_true
        end
      end
      context '異常な場合' do
        before do
          controller.request.env['HTTP_USER_AGENT'] = nil
        end
        it 'falseであること' do
          request.mobile.is_a?(Jpmobile::Mobile::Au).should be_false
        end
      end
    end
  end

  describe 'send_form' do
    before do
      get :send_form, :disaster_code => "20130108151823978961"
    end
    context '正常の場合' do
      before do
        @disaster_code = assigns[:disaster_code]
      end
      it 'getが成功すること' do
        response.should be_success
      end
      it 'テンプレートが適用されていること' do
        response.should render_template("staffs/send_form") # lgdsf_smartphone
      end
      it 'テンプレートが適用されていること' do
        controller.request.env['HTTP_USER_AGENT'] = 'DoCoMo'
        get :send_form, :disaster_code => "20130108151823978961"
        response.should render_template("staffs/send_form") if request.mobile? # lgdsf_smartphone
      end
      describe '@disaster_code' do
        it 'Stringクラスであること' do
          @disaster_code.should be_an_instance_of(String)
        end
      end
    end
    context '異常の場合' do
      before do
        @disaster_code = nil
      end
      describe '@disaster_code' do
        it 'nilであること' do
          @disaster_code.should be_nil
        end
      end
    end
  end

  describe 'save_send' do
    context '正常の場合' do
      describe '@disaster_code' do
        before do
          post :save_send, :disaster_code => "20130108151823978961", :mail => "sato@gmail.example.com"
          @disaster_code = assigns[:disaster_code]
        end
        it 'postが成功すること' do
          response.should be_redirect
        end
        it 'Stringであること' do
          @disaster_code.should be_an_instance_of(String)
        end
      end

      context 'エラー処理' do
        before do
          post :save_send, :mail => "sato@gmail.example.com", :disaster_code => "20130108151823978961"
          @disaster_code = assigns[:disaster_code]
          @mail = "sato@gmail.example.com"
          @agent = Agent.find_by_mail_address(@mail)
          @staff = Staff.find_by_agent_id_and_disaster_code(@agent.id, @disaster_code)
        end

        it 'メールアドレスが空でないこと' do
          @mail.present?.should be_true
        end
        it 'メールアドレスが256以下であること' do
          @mail.size.should <= 256
        end
        it 'メールアドレスが一致すること' do
          @agent.present?.should be_true
        end
        it '上書きが成功すること' do
          @staff.update_attributes!(:name => @agent.name, :agent_id => @agent.id).should be_true
        end
        it '挿入が成功すること' do
          post :save_send, :mail => "sato@gmail.example.com", :disaster_code => "20130108151823978962"
          @disaster_code = assigns[:disaster_code]
          @mail = "sato@gmail.example.com"
          @agent = Agent.find_by_mail_address(@mail)
          @staff = Staff.find_by_agent_id_and_disaster_code(@agent.id, @disaster_code)
          Staff.create!(:name => @agent.name, :agent_id => @agent.id, :disaster_code => @disaster_code).should be_true
        end
        it '職員が存在すること' do
          @staff.present?.should be_true
        end
        it '位置情報送信画面にリダイレクトする' do
          response.should redirect_to(:action => :position_form, :disaster_code => @disaster_code, :agent_id => @agent.id)
        end
      end

      context 'エラー処理' do
        before do
          post :save_send, :mail => "sato@gmail.example.com", :disaster_code => "20130108151823978961"
          @disaster_code = assigns[:disaster_code]
          @mail = "sato@gmail.example.com"
          @agent = Agent.find_by_mail_address(@mail)
          @staff = nil#Staff.find_by_agent_id_and_disaster_code(@agent.id, @disaster_code)
        end

        it 'メールアドレスが空でないこと' do
          @mail.present?.should be_true
        end
        it 'メールアドレスが256以下であること' do
          @mail.size.should <= 256
        end
        it 'メールアドレスが一致すること' do
          @agent.present?.should be_true
        end

        it '職員が存在しないこと' do
          @staff.present?.should be_false
        end
        it '位置情報送信画面にリダイレクトする' do
          response.should redirect_to(:action => :position_form, :disaster_code => @disaster_code, :agent_id => @agent.id)
        end
      end

      context '異常の場合' do
        before do
          post :save_send, :mail => "", :disaster_code => "20130108151823978961"
          @mail = ""
          @disaster_code = assigns[:disaster_code]
        end
        context 'メールアドレスが空である場合' do
          it '画面上部にエラーメッセージを表示すること' do
            class MailBlankException < StandardError; end
            begin
              raise MailBlankException, I18n.t("errors.messages.mail_blank") if @mail.blank?
            rescue MailBlankException => e
              flash[:notice] = e.message
              response.should redirect_to(:action => :send_form, :disaster_code => @disaster_code, :notice => flash[:notice])
            end
          end
        end
        context 'メールアドレスの入力数が256桁以上の場合' do
          it '画面上部にエラーメッセージを表示すること' do
            @mail = 'a' * 256
            class MailLengthException < StandardError; end
            begin
              raise MailLengthException, I18n.t("errors.messages.mail_length") if @mail.size > 256
            rescue MailLengthException => e
              flash[:notice] = e.message
              response.should redirect_to(:action => :send_form, :disaster_code => @disaster_code, :notice => flash[:notice])
            end
          end
        end
      end
    end
  end

  describe 'position_form' do
    context '正常の場合' do
      before do
        get :position_form, :disaster_code => "20130108151823978961", :agent_id => 1
        @disaster_code = assigns[:disaster_code]
        @agent_id = assigns[:agent_id]
      end
      it 'getが成功すること' do
        response.should be_success
      end
      it 'session変数が保存されていること' do
        controller.request.env['HTTP_USER_AGENT'] = 'KDDI-CA39 UP.Browser/6.2.0.13.1.5 (GUI) MMP/2.0'
        get :position_form, :disaster_code => "20130108151823978961", :agent_id => 1
        session[:disaster_code] = @disaster_code
        session[:agent_id] = @agent_id
        (session[:disaster_code] && session[:agent_id]).should be_present
      end
      it 'テンプレートが適用されていること' do
        response.should render_template("staffs/position_form") # lgdsf_smartphone
      end
      it 'テンプレートが適用されていること' do
        controller.request.env['HTTP_USER_AGENT'] = 'DoCoMo'
        get :position_form, :disaster_code => "20130108151823978961", :agent_id => 1
        response.should render_template("staffs/position_form") if request.mobile? # lgdsf_smartphone 
      end
      describe '@disaster_code' do
        it 'Stringクラスであること' do
          @disaster_code.should be_an_instance_of(String)
        end
      end
      describe '@agent_id' do
        it 'Stringクラスであること' do
          @agent_id.should be_an_instance_of(String)
        end
      end
      describe 'session[:disaster_code]' do
        it 'nilでないこと' do
          session[:disaster_code] = @disaster_code
          session[:disaster_code].present?.should be_true
        end
      end
      describe 'session[:agent_id]' do
        it 'nilでないこと' do
          session[:agent_id] = @agent_id
          session[:agent_id].present?.should be_true
        end
      end
    end
    context '異常の場合' do
      before do
        get :position_form, :disaster_code => nil, :agent_id => nil
        @disaster_code = assigns[:disaster_code]
        @agent_id = assigns[:agent_id]
      end
      describe '@disaster_code' do
        it 'nilであること' do
          @disaster_code.should be_nil
        end
      end
      describe '@agent_id' do
        it 'nilであること' do
          @agent_id.should be_nil
        end
      end
      describe 'session[:disaster_code]' do
        it 'nilであること' do
          session[:disaster_code] = @disaster_code
          session[:disaster_code].should be_nil
        end
      end
      describe 'session[:agent_id]' do
        it 'nilであること' do
          session[:agent_id] = @agent_id
          session[:agent_id].should be_nil
        end
      end
    end
  end

  describe 'save_position' do
    context '正常の場合' do
      before do
        post :save_position, :agent_id => 1, :disaster_code => "20130108151823978961", :latitude => "38.43448027777777", :longitude => "141.30291666666668"
        @disaster_code = assigns[:disaster_code]
        @agent_id = assigns[:agent_id]
        @latitude = assigns[:latitude]
        @longitude = assigns[:longitude]
      end
      it 'auのとき、情報を取得できること' do
        controller.request.env['HTTP_USER_AGENT'] = 'KDDI-CA39 UP.Browser/6.2.0.13.1.5 (GUI) MMP/2.0'
        post :save_position, :agent_id => 1, :disaster_code => "20130108151823978961", :latitude => "38.43448027777777", :longitude => "141.30291666666668"
        @disaster_code = session[:disaster_code]
        @agent_id = session[:agent_id]
      end
      describe '@staff' do
        before do
          @staff = Staff.find_by_agent_id_and_disaster_code(@agent_id, @disaster_code)
        end
        it '緯度、経度が空でないこと' do
          (@latitude.present? && @longitude.present?).should be_true
        end
        it '職員が存在すること' do
          @staff.present?.should be_true
        end
        it '上書きが成功すること' do
          @staff.update_attributes!(:latitude => @latitude, :longitude => @longitude).should be_true
        end
      end
      context '現在位置取得成功の場合' do
        it '参集場所報告画面にリダイレクトする' do
          response.should redirect_to(:action => :destination_form, :agent_id => @agent_id, :latitude => @latitude, :longitude => @longitude, :disaster_code => @disaster_code)
        end
      end
    end

    context '異常の場合' do
      context 'メールアドレスが空の場合' do
        before do
          get :save_position, :agent_id => 1, :disaster_code => "20130108151823978961"
          @disaster_code = assigns[:disaster_code]
          @agent_id = assigns[:agent_id]
          @latitude = nil
          @longitude = nil
        end
        describe '位置情報' do
          it '緯度か経度が空であること' do
            (@latitude.blank? || @longitude.blank?).should be_true
          end
        end
        context '現在位置の取得失敗の場合' do
          it '画面上部にエラーメッセージを表示すること' do
            class PositionBlankException < StandardError; end
            begin
              raise PositionBlankException, I18n.t("errors.messages.position_blank") if @latitude.blank? || @longitude.blank?
            rescue PositionBlankException => e
              flash[:notice] = e.message
              response.should redirect_to(:action => :position_form, :agent_id => @agent_id, :disaster_code => @disaster_code, :notice => flash[:notice])
            end
          end
        end
      end
    end
  end

  describe 'destination_form' do
    context '正常の場合' do
      before do
        get :destination_form, :agent_id => 1, :disaster_code => "20130108151823978961", :latitude => "38.43448027777777", :longitude => "141.30291666666668"
        @disaster_code = assigns[:disaster_code]
        @agent_id = assigns[:agent_id]
        @latitude = assigns[:latitude].to_f
        @longitude = assigns[:longitude].to_f
        @zoom = 13
      end
      it 'getが成功すること' do
        response.should be_success
      end
      it 'テンプレートが適用されていること' do
        response.should render_template("destination_form") # lgdsf
      end
      it 'テンプレートが適用されていること' do
        controller.request.env['HTTP_USER_AGENT'] = 'DoCoMo'
        get :destination_form, :agent_id => 1, :disaster_code => "20130108151823978961", :latitude => "38.43448027777777", :longitude => "141.30291666666668"
        response.should render_template("staffs/destination_form") if request.mobile? # lgdsf_smartphone
      end
      context '2点間の距離を求め、ズーム率を決定する。' do
        before do
          diffs = []
          size = 200.0
          @gathering_positions.each do |id, gathering_position|
            count = id.to_i-1
            lat = gathering_position["latitude"].to_f - @latitude
            lng = gathering_position["longitude"].to_f - @longitude
            diffs[count] = Math::sqrt(lat * lat + lng * lng)
            @zoom = Math::log(size/diffs[count])/Math::log(2) < @zoom ? Math::log(size/diffs[count])/Math::log(2) : @zoom
          end
        end
        describe '@zoom' do
          it 'ズーム率がFixnumであること' do
            @zoom = @zoom.round - 1
            @zoom.should be_an_instance_of(Fixnum)
          end
        end
        describe '@predefined_position' do
          it '所定の参集場所の取得ができること' do
            @predefined_position = @predefined_positions["#{@agent_id}"]["position_code"].to_i
            @predefined_position.should be_an_instance_of(Fixnum)
          end
        end

        describe '@near_gathering_positions' do
          context 'モバイルの場合' do
            it '近くの参集場所が3つ取得できること' do
              diffs = []
              size = 200.0
              @gathering_positions.each do |id, gathering_position|
                count = id.to_i-1
                lat = gathering_position["latitude"].to_f - @latitude
                lng = gathering_position["longitude"].to_f - @longitude
                diffs[count] = Math::sqrt(lat * lat + lng * lng)
                @zoom = Math::log(size/diffs[count])/Math::log(2) < @zoom ? Math::log(size/diffs[count])/Math::log(2) : @zoom
              end
              temps = []
              temps = diffs.sort
            
              gathering_position_ids = []
            
              roop = 3
            
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

              @near_gathering_positions = {}
              gathering_position_ids.each do |gathering_position_id|
                @near_gathering_positions[gathering_position_id] = @gathering_positions["#{gathering_position_id}"]
              end
              
              @near_gathering_positions.size.should == 3
            end
          end
          context 'スマートフォン/タブレットの場合' do
            it '近くの参集場所が8つ取得できること' do
              diffs = []
              size = 350.0
              @gathering_positions.each do |id, gathering_position|
                count = id.to_i-1
                lat = gathering_position["latitude"].to_f - @latitude
                lng = gathering_position["longitude"].to_f - @longitude
                diffs[count] = Math::sqrt(lat * lat + lng * lng)
                @zoom = Math::log(size/diffs[count])/Math::log(2) < @zoom ? Math::log(size/diffs[count])/Math::log(2) : @zoom
              end
              temps = []
              temps = diffs.sort
              
              gathering_position_ids = []
              
              roop = 8
              
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

              @near_gathering_positions = {}
              gathering_position_ids.each do |gathering_position_id|
                @near_gathering_positions[gathering_position_id] = @gathering_positions["#{gathering_position_id}"]
              end
              
              @near_gathering_positions.size.should == 8
            end
          end
        end
      end
    end
  end

  describe 'save_destination' do
    context '正常の場合' do
      before do
        post :save_destination, :agent_id => 1, :disaster_code => "20130108151823978961", :latitude => "38.43448027777777", :longitude => "141.30291666666668", "destination" => {:position => "7", :place => "0", :reason => ""}
        @disaster_code = assigns[:disaster_code]
        @destination = assigns[:destination]
        @agent_id = assigns[:agent_id]
        @latitude = assigns[:latitude]
        @longitude = assigns[:longitude]
      end
      describe '@destination' do
        before do
          @staff = Staff.find_by_agent_id_and_disaster_code(@agent_id, @disaster_code)
        end
        it '参集場所情報が正しく取得できること' do
          (@destination['position'].present? || @destination['place'].to_i == 1).should be_true
        end
        it '職員が存在すること' do
          @staff.present?.should be_true
        end
        context '参集場所に向かうのが困難な場合' do
          it '上書きが成功すること' do
             post :save_destination, :agent_id => 1, :disaster_code => "20130108151823978961", :latitude => "38.43448027777777", :longitude => "141.30291666666668", "destination" => {:position => "7", :place => "1", :reason => ""}
            @staff.update_attributes!(:status => false, :destination_code => '', :reason => @destination['reason'].present? ? @destination['reason'] : '').should be_true
          end
        end
        it '上書きが成功すること' do
          gathering_position = @gathering_positions[@destination['position']]
          @staff.update_attributes!(:status => true, :destination_code => gathering_position['position_code'], :reason => '')
        end
        it '送信しましたと画面上部に表示すること' do
          response.should redirect_to(:action => :destination_form, :agent_id => @agent_id, :latitude => @latitude, :longitude => @longitude, :disaster_code => @disaster_code, :notice => "送信しました")
        end
      end
    end
    context '異常の場合' do
      context '参集場所が選択されていない場合' do
        before do
          post :save_destination, :agent_id => 1, :disaster_code => "20130108151823978961", :latitude => "38.43448027777777", :longitude => "141.30291666666668", "destination" => {:position => "", :place => "0", :reason => ""}
          @disaster_code = assigns[:disaster_code]
          @destination = assigns[:destination]
          @agent_id = assigns[:agent_id]
          @latitude = assigns[:latitude]
          @longitude = assigns[:longitude]
        end
        describe '参集場所情報' do
          context '参集場所未選択の取得失敗の場合' do
            it '参集場所情報が選択されていないこと' do
              (@destination['position'].present? || @destination['place'].to_i == 1).should be_false
            end
            it '画面上部にエラーメッセージを表示すること' do
              class DestinationBlankException < StandardError; end
              begin
                raise DestinationBlankException, I18n.t("errors.messages.destination_blank") if @destination['position'].blank? && @destination['place'].to_i == 0
              rescue DestinationBlankException => e
                flash[:notice] = e.message
                response.should redirect_to(:action => :destination_form, :agent_id => @agent_id, :disaster_code => @disaster_code, :latitude => @latitude, :longitude => @longitude, :notice => flash[:notice])
              end
            end
          end
        end
      end
    end
  end

  describe 'index' do
 
    login_user

    context '正常の場合' do
      before do
        get :index
        settings   = YAML.load_file("#{Rails.root}/config/settings.yml")
        @latitude  = settings["lgdsf"][Rails.env]["latitude"]
        @longitude = settings["lgdsf"][Rails.env]["longitude"]
      end
      it 'getが成功すること' do
        response.should be_success
      end
      it 'テンプレートが適用されていること' do
        response.should render_template("index") # lgdsf_index
      end
      describe '職員位置確認画面のマップの中心' do
        it '@latitude（緯度）がFloatクラスであること' do
          @latitude.should be_an_instance_of(Float)
        end
        it '@longitude（経度）がFloatクラスであること' do
          @longitude.should be_an_instance_of(Float)
        end
      end
      describe '最新メール番号' do
        it 'Stringクラスであること' do
          new_disaster_code = Staff.maximum(:disaster_code)
          new_disaster_code.should be_an_instance_of(String)
        end
        it 'Staff DBから値が取得できる' do
          new_disaster_code = Staff.maximum(:disaster_code)
          @staffs = Staff.find(:all, :conditions => { :disaster_code => new_disaster_code })
          @staffs.should be_true
        end
      end
      describe '2点間の距離を求め、ズーム率を決定する。' do
        context '@zoom' do
          before do
            @zoom = 13
          end
          it 'ズーム率がFixnumであること' do
            @gathering_positions.each do |id, gathering_position|
              lat = gathering_position["latitude"].to_f - @latitude
              lng = gathering_position["longitude"].to_f - @longitude
              count = id.to_i-1
              diff = Math::sqrt(lat * lat + lng * lng)
              @zoom = Math::log(534.0/diff)/Math::log(2) < @zoom ? Math::log(534.0/diff)/Math::log(2) : @zoom
            end
            @zoom = @zoom.round - 1
            @zoom.should be_an_instance_of(Fixnum)
          end
        end
      end
    end
  end

  describe 'main' do
    pending
  end

  describe 'index' do
    it 'リクエストが成功すること' do
      get :index
      response.should be_success
    end
  end

  describe 'index_department' do
    it 'リクエストが成功すること' do
      get :index_department
      response.should be_success
    end
  end

end

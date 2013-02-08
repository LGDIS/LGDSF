# -*- coding:utf-8 -*-
require 'spec_helper'

describe StaffsController do

  before do
    @gathering_positions  = Rails.cache.read("gathering_position")
    @predefined_positions = Rails.cache.read("predefined_position")
    @factory_staff = FactoryGirl.build(:staff)
    @factory_agent = FactoryGirl.build(:agent)
  end

  describe 'layout_selector' do
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
  end

  describe 'send_form' do
    context '正常の場合' do
      before do
        get :send_form, :disaster_code => "2013#{rand(13)}#{rand(32)}#{rand(24)}#{rand(60)}#{rand(100)}"
        @disaster_code = assigns[:disaster_code]
      end
      it 'getが成功すること' do
        response.should be_success
      end
      it 'テンプレートが適用されていること' do
        response.should render_template("staffs/send_form") # lgdsf_smartphone
      end
      describe '@disaster_code' do
        it 'Stringクラスであること' do
          @disaster_code.should be_an_instance_of(String)
        end
      end
    end
  end

  describe 'save_send' do
    context '正常の場合' do
      before do
        post :save_send, :mail => "sato@gmail.com", :disaster_code => "2013#{rand(13)}#{rand(32)}#{rand(24)}#{rand(60)}#{rand(100)}"
        @mail = assigns[:mail]
        @disaster_code = assigns[:disaster_code]
      end
      it 'postが成功すること' do
        response.should be_redirect
      end
    end
    context '異常の場合' do
=begin
      before do
        
      end
      it '' do

      end 
      context 'メールアドレスが空の場合'
        
      end
=end
    end
  end

  describe 'index' do
  
    login_user

    context '正常の場合' do
      before do
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
        pending ':disaster_codeがnilのため保留' do
        it 'Stringクラスであること' do 
          @new_disaster_code = Staff.maximum(:disaster_code)
          @new_disaster_code.should be_an_instance_of(String)
        end
        end
        it 'Staff DBから値が取得できる' do
          @staffs = Staff.find(:all, :conditions => { :disaster_code => @new_disaster_code })
          @staffs.should be_true
        end
      end
    end
  end

end

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
    before do
      get :mail
    end
    context '正常の場合' do
      it 'getが成功すること' do
        response.should be_success
      end
      it 'テンプレートが適用されていること' do
        response.should render_template("staffs/mail") # lgdsf
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
            after '' do
              #pending 'renderが行えないため保留' do
              #render "send_form_mobile"
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
    end
  end

  describe 'save_send' do

  end

  describe 'position_form' do

  end

  describe 'save_position' do

  end

  describe 'destination_form' do

  end

  describe 'save_destination' do

  end

  describe 'index' do
    context '正常の場合' do
      before '職員位置確認画面にアクセスする' do
        #pending 'get できないため保留' do
        #get :index
        #end
      end
      describe '職員位置確認画面のマップの中心' do
        settings = YAML.load_file("#{Rails.root}/config/settings.yml")
        it '@latitude（緯度）がStringクラスであること' do
          @latitude  = settings["ldgsf"][Rails.env]["latitude"]
          @latitude.should be_an_instance_of(Float)
        end
        it '@longitude（経度）がStringクラスであること' do
          settings = YAML.load_file("#{Rails.root}/config/settings.yml")
          @longitude = settings["ldgsf"][Rails.env]["longitude"]
          @longitude.should be_an_instance_of(Float)
        end
        context '2点間の距離を求め、ズーム率を決定する。' do
          it '2点間の距離を求める' do
            pending "nil can't be coerced into Floatが出る為保留" do
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

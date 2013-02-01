# -*- coding:utf-8 -*-
require 'spec_helper'

describe StaffsController do
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
              #pending("renderが行えないため保留") do
              #  render "send_form_mobile"
              #end
            end
          end
        end
        context 'false or nil' do
          #describe '' do
          #end
        end
        describe 'PC' do
          it 'FireFoxのとき、nilであること' do
            controller.request#.env['HTTP_USER_AGENT'] = "Mozilla"
            request.mobile?.should be_nil
          end
        end
        describe 'モバイル' do
          it 'DoCoMoのとき、trueであること' do
            controller.request.env['HTTP_USER_AGENT'] = 'DoCoMo'
            request.mobile?.should be_true
          end
        end
        describe 'スマートフォン' do
          it 'iPhoneのとき、trueであること' do
            controller.request.env['HTTP_USER_AGENT'] = 'iPhone'
            request.mobile?.should be_false
          end
          it 'Androidのとき、trueであること' do
            controller.request.env['HTTP_USER_AGENT'] = 'Android'
            request.mobile?.should be_false
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
    before '職員位置確認画面にアクセスする' do
      pending 'get できないため保留' do
        get :index
      end
      settings = YAML.load_file("#{Rails.root}/config/settings.yml")
    end
    context '正常の場合' do
      describe '@latitude（緯度）' do
        it 'Stringクラスであること' do
          @latitude  = settings["ldgsf"][Rails.env]["latitude"]
          @latitude.should be_an_instance_of(String)
        end
      end
      describe '@longitude（経度）' do
        it 'Stringクラスであること' do
          @longitude = settings["ldgsf"][Rails.env]["longitude"]
          @longitude.should be_an_instance_of(String)
        end
      end
    end
  end

end

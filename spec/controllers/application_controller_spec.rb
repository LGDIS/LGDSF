# -*- coding:utf-8 -*-
require 'spec_helper'

describe ApplicationController do
  describe 'layout' do
    before :each do
      @controller = ApplicationController.new
    end
    context '通常画面のとき' do
      it 'applicationレイアウトを使用すること' do
        @controller.send(:layout_by_resource).should == "application"
      end
    end
    context 'メール確認画面などのとき' do
      it 'usersレイアウトを使用すること' do
        @controller.stub!(:devise_controller?).and_return(true)
        @controller.stub!(:user_signed_in?).and_return(false)
        @controller.send(:layout_by_resource).should == "users"
      end
    end
  end
end

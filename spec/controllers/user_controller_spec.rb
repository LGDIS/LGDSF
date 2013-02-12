# -*- coding:utf-8 -*-
require 'spec_helper'

describe UsersController do
  # Deviseログイン認証
  login_user

  describe "#after_sign_out_path_for" do
    subject { get :destroy }
    it { should be_redirect }
    it { should redirect_to(new_user_session_url) }
  end
  
  describe "create" do
    context '正常な場合' do
      before do
        @email = "test@test.jp"
        @password = "test@test.jp"
      end
      it 'ログイン名が空でないこと' do
        @email.blank?.should be_false
      end
      it 'パスワードが空でないこと' do
        @password.blank?.should be_false
      end
      it 'ユーザが見つかること' do
        user = User.find_by_email(@email)
        user.present?.should be_true
      end
    end
    context '異常な場合' do
      before do
        @email = nil
        @password = nil
      end
      it 'ログイン名が空であること' do
        @email.blank?.should be_true
      end
      it 'パスワードが空であること' do
        @password.blank?.should be_true
      end
    end
  end

end

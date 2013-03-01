# -*- coding:utf-8 -*-
require 'spec_helper'

def mock_user(stubs={})
  # Userクラスのオブジェクトのモックを作成
  @mock_user ||= mock_model(User, stubs)
end

describe UsersController do

  describe "#after_sign_out_path_for" do
    login_user
    subject { get :destroy }
    it { should be_redirect }
    it { should redirect_to(new_user_session_url) }
  end

  describe "create" do
    context '正常な場合' do
      it 'ユーザが見つかること' do
        user = mock_user(:authenticatable_salt => "01")
        User.should_receive(:find_by_login_and_provider).with("test@example.com", nil).and_return(user)
        user.should_not be_nil
        request.env['devise.mapping'] = Devise.mappings[:user]
        post :create, :user=> {:login=>"test@example.com", :password=>"test@example.com"}
      end
    end
    context '異常な場合' do
      context 'ログイン名、パスワードが空の場合' do
        before do
          @request.env["devise.mapping"] = Devise.mappings[:user]
          post :create, :user => {:login => "", :password => ""}
        end
        it 'エラーメッセージが表示されること' do
          response.should be_success
          flash[:alert].should == "ログイン名またはパスワードが正しくありません。"
        end
      end
      context 'ログイン名が空の場合' do
        before do
          @request.env["devise.mapping"] = Devise.mappings[:user]
          post :create, :user => {:login => "", :password => "test@example.com"}
        end
        it 'エラーメッセージが表示されること' do
          response.should be_success
          flash[:alert].should == "ログイン名またはパスワードが正しくありません。"
        end
      end
      context 'パスワードが空の場合' do
        before do
          @request.env["devise.mapping"] = Devise.mappings[:user]
          post :create, :user => {:login => "test@example.com", :password => ""}
        end
        it 'エラーメッセージが表示されること' do
          response.should be_success
          flash[:alert].should == "ログイン名またはパスワードが正しくありません。"
        end
      end
    end
  end
end

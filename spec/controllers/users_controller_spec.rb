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
        a = mock_user(:authenticatable_salt => "01")
        User.should_receive(:find_by_email_and_provider).with("test@test.jp", nil).and_return(a)
        a.should_not be_nil
        request.env['devise.mapping'] = Devise.mappings[:user]
        post :create, :user=> {:email=>"test@test.jp", :password=>"test@test.jp"}
      end
    end
    context '異常な場合' do
      context 'ログイン名、パスワードが空の場合' do
        before do
          @request.env["devise.mapping"] = Devise.mappings[:user]
          post :create, :user => {:email => "", :password => ""}
        end
        it 'エラーメッセージが表示されること' do
          flash[:alert].should == "ログイン名またはパスワードが正しくありません。"
        end
        it 'newへリダイレクトすること' do
          response.should redirect_to(:action => :new)
        end
      end
      context 'ログイン名が空の場合' do
        before do
          @request.env["devise.mapping"] = Devise.mappings[:user]
          post :create, :user => {:email => "", :password => "test@test.jp"}
        end
        it 'エラーメッセージが表示されること' do
          flash[:alert].should == "ログイン名を入力してください。"
        end
        it 'newへリダイレクトすること' do
          response.should redirect_to(:action => :new)
        end
      end
      context 'パスワードが空の場合' do
        before do
          @request.env["devise.mapping"] = Devise.mappings[:user]
          post :create, :user => {:email => "test@test.jp", :password => ""}
        end
        it 'エラーメッセージが表示されること' do
          flash[:alert].should == "パスワードを入力してください。"
        end
        it 'newへリダイレクトすること' do
          response.should redirect_to(:action => :new)
        end
      end
    end
  end
end

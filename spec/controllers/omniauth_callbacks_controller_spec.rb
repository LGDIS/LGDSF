# -*- coding:utf-8 -*-
require 'spec_helper'

describe OmniauthCallbacksController do

  describe '#google' do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
    end
    context '正常の場合' do
      before do
        @user = mock_model(User, {:persisted? => true, :authenticatable_salt => "00"})
        @omniauth_cred = {}
        controller.request.env['omniauth.auth'] = @omniauth_cred
      end
      it 'getが成功すること' do
        User.should_receive(:find_for_open_id).with(@omniauth_cred, nil).and_return(@user)
        get :google
        response.should be_redirect
      end
      it 'リクエスト情報のユーザでログインすること' do
        User.should_receive(:find_for_open_id).with(@omniauth_cred, nil).and_return(@user)
        get :google
        response.should redirect_to(:root)
      end
    end
    context '異常な場合' do
      context 'ユーザ情報を取得できないとき' do
        it '発生する例外をrescueせずそのまま返却する' do
          User.should_receive(:find_for_open_id).with(@omniauth_cred, nil).and_raise(User::ExternalAuthDisabled)
          proc{get :google}.should raise_error(User::ExternalAuthDisabled)
        end
      end
    end
  end

  describe '#twitter' do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
    end
    context '正常の場合' do
      before do
        @user = mock_model(User, {:persisted? => true, :authenticatable_salt => "00"})
        @omniauth_cred = {}
        controller.request.env['omniauth.auth'] = @omniauth_cred
      end
      it 'getが成功すること' do
        User.should_receive(:find_for_oauth).with(@omniauth_cred, nil).and_return(@user)
        get :twitter
        response.should be_redirect
      end
      it 'リクエスト情報のユーザでログインすること' do
        User.should_receive(:find_for_oauth).with(@omniauth_cred, nil).and_return(@user)
        get :twitter
        response.should redirect_to(:root)
      end
    end
    context '異常な場合' do
      context 'ユーザ情報を取得できないとき' do
        it '発生する例外をrescueせずそのまま返却する' do
          User.should_receive(:find_for_oauth).with(@omniauth_cred, nil).and_raise(User::ExternalAuthDisabled)
          proc{get :twitter}.should raise_error(User::ExternalAuthDisabled)
        end
      end
    end
  end

  describe '#facebook' do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
    end
    context '正常の場合' do
      before do
        @user = mock_model(User, {:persisted? => true, :authenticatable_salt => "00"})
        @omniauth_cred = {}
        controller.request.env['omniauth.auth'] = @omniauth_cred
      end
      it 'getが成功すること' do
        User.should_receive(:find_for_oauth).with(@omniauth_cred, nil).and_return(@user)
        get :facebook
        response.should be_redirect
      end
      it 'リクエスト情報のユーザでログインすること' do
        User.should_receive(:find_for_oauth).with(@omniauth_cred, nil).and_return(@user)
        get :facebook
        response.should redirect_to(:root)
      end
    end
    context '異常な場合' do
      context 'ユーザ情報を取得できないとき' do
        it '発生する例外をrescueせずそのまま返却する' do
          User.should_receive(:find_for_oauth).with(@omniauth_cred, nil).and_raise(User::ExternalAuthDisabled)
          proc{get :facebook}.should raise_error(User::ExternalAuthDisabled)
        end
      end
    end
  end

  describe '#openam' do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
    end
    context '正常の場合' do
      before do
        @user = mock_model(User, {:persisted? => true, :authenticatable_salt => "00"})
        @omniauth_cred = {}
        controller.request.env['omniauth.auth'] = @omniauth_cred
      end
      it 'getが成功すること' do
        User.should_receive(:find_for_saml).with(@omniauth_cred, nil).and_return(@user)
        get :openam
        response.should be_redirect
      end
      it 'リクエスト情報のユーザでログインすること' do
        User.should_receive(:find_for_saml).with(@omniauth_cred, nil).and_return(@user)
        get :openam
        response.should redirect_to(:root)
      end
    end
    context '異常な場合' do
      context 'ユーザ情報を取得できないとき' do
        it '発生する例外をrescueせずそのまま返却する' do
          User.should_receive(:find_for_saml).with(@omniauth_cred, nil).and_raise(User::ExternalAuthDisabled)
          proc{get :openam}.should raise_error(User::ExternalAuthDisabled)
        end
      end
    end
  end

end

# -*- coding:utf-8 -*-
require 'spec_helper'

describe User do

  describe '#find_for_open_id' do
    before :each do
      SETTINGS['external_auth']['enable'] = true
    end
    subject { User.find_for_open_id(access_token, nil) }
    let(:access_token) {
      double("OmniAuth::AuthHash",
             :provider => "google",
             :uid => "unique-value",
             :info => double("OmniAuth::AuthHash::InfoHash", :email => "user@google.example.com")
             )
    }
    describe '正常の場合' do
      context '新規ユーザの場合' do
        it 'ユーザ情報を返却すること' do
          subject.should be_a_kind_of(User)
        end
        it '指定した新規ユーザ情報であること' do
          subject.login.should == "user@google.example.com"
        end
      end
      context '既存ユーザの場合' do
        let(:created_user) { FactoryGirl.create(:created_google_user) }
        it 'ユーザ情報を返却すること' do
          subject.should be_a_kind_of(User)
        end
        it '指定した既存ユーザ情報であること' do
          subject.should do |u|
            u.email.should    == created_user.email
            u.provider.should == created_user.provider
            u.uid.should      == created_user.uid
          end
        end
      end
    end
    describe '異常の場合' do
      context '機能が無効に設定されている場合' do
        before :each do
          SETTINGS['external_auth']['enable'] = false
        end
        it 'ExternalAuthDisabled例外が発生すること' do
          lambda{subject}.should raise_error(User::ExternalAuthDisabled)
        end
      end
      context '認可プロバイダがgoogleでない場合' do
        let(:access_token) {
          double("OmniAuth::AuthHash",
                 :provider => "psedo-google",
                 :uid => "unique-value",
                 :info => double("OmniAuth::AuthHash::InfoHash", :email => "user@google.example.com")
                 )
        }
        it 'InvalidAuthProvider例外が発生すること' do
          lambda{subject}.should raise_error(User::InvalidAuthProvider)
        end
      end
    end
  end

  describe '#find_for_oauth' do
    before :each do
      SETTINGS['external_auth']['enable'] = true
    end
    subject { User.find_for_oauth(access_token, nil) }
    describe '正常の場合' do
      describe '(Twitter)' do
        let(:access_token) {
          double("OmniAuth::AuthHash",
                 :provider => "twitter",
                 :uid => "unique-value",
                 :info => double("OmniAuth::AuthHash::InfoHash", :nickname => "twittername")
                 )
        }
        context '新規ユーザの場合' do
          it 'ユーザ情報を返却すること' do
            subject.should be_a_kind_of(User)
          end
          it '指定した新規ユーザ情報であること' do
            subject.login.should == "@twittername"
          end
        end
        context '既存ユーザの場合' do
          let(:created_user) { FactoryGirl.create(:created_twitter_user) }
          it 'ユーザ情報を返却すること' do
            subject.should be_a_kind_of(User)
          end
          it '指定した既存ユーザ情報であること' do
            subject.should do |u|
              u.email.should    == created_user.email
              u.provider.should == created_user.provider
              u.uid.should      == created_user.uid
            end
          end
        end
      end
      describe '(Facebook)' do
        let(:access_token) {
          double("OmniAuth::AuthHash",
                 :provider => "facebook",
                 :uid => "unique-value",
                 :info => double("OmniAuth::AuthHash::InfoHash", :name => "real name")
                 )
        }
        context '新規ユーザの場合' do
          it 'ユーザ情報を返却すること' do
            subject.should be_a_kind_of(User)
          end
          it '指定した新規ユーザ情報であること' do
            subject.login.should == "real name"
          end
        end
        context '既存ユーザの場合' do
          let(:created_user) { FactoryGirl.create(:created_facebook_user) }
          it 'ユーザ情報を返却すること' do
            subject.should be_a_kind_of(User)
          end
          it '指定した既存ユーザ情報であること' do
            subject.should do |u|
              u.email.should    == created_user.email
              u.provider.should == created_user.provider
              u.uid.should      == created_user.uid
            end
          end
        end
      end
    end
    describe '異常の場合' do
      let(:access_token) {
        double("OmniAuth::AuthHash",
               :provider => "twitter",
               :uid => "unique-value",
               :info => double("OmniAuth::AuthHash::InfoHash", :nickname => "twittername")
               )
      }
      context '機能が無効に設定されている場合' do
        before :each do
          SETTINGS['external_auth']['enable'] = false
        end
        it 'ExternalAuthDisabled例外が発生すること' do
          lambda{subject}.should raise_error(User::ExternalAuthDisabled)
        end
      end
      context '認可プロバイダがTwitterでもFacebookでもない場合' do
        let(:access_token) {
          double("OmniAuth::AuthHash",
                 :provider => "psedo-twitter",
                 :uid => "unique-value",
                 :info => double("OmniAuth::AuthHash::InfoHash", :nickname => "twittername")
                 )
        }
        it 'InvalidAuthProvider例外が発生すること' do
          lambda{subject}.should raise_error(User::InvalidAuthProvider)
        end
      end
    end
  end

  describe '#find_for_saml' do
    before :each do
      SETTINGS['external_auth']['enable'] = true
    end
    subject { User.find_for_saml(access_token, nil) }
    let(:access_token) {
      double("OmniAuth::AuthHash",
             :provider => "openam",
             :uid => "unique-value",
             :info => double("OmniAuth::AuthHash::InfoHash")
             )
    }
    describe '正常の場合' do
      context '新規ユーザの場合' do
        it 'ユーザ情報を返却すること' do
          subject.should be_a_kind_of(User)
        end
        it '指定した新規ユーザ情報であること' do
          subject.login.should == "unique-value"
        end
      end
      context '既存ユーザの場合' do
        let(:created_user) { FactoryGirl.create(:created_openam_user) }
        it 'ユーザ情報を返却すること' do
          subject.should be_a_kind_of(User)
        end
        it '指定した既存ユーザ情報であること' do
          subject.should do |u|
            u.email.should    == created_user.email
            u.provider.should == created_user.provider
            u.uid.should      == created_user.uid
          end
        end
      end
    end
    describe '異常の場合' do
      context '機能が無効に設定されている場合' do
        before :each do
          SETTINGS['external_auth']['enable'] = false
        end
        it 'ExternalAuthDisabled例外が発生すること' do
          lambda{subject}.should raise_error(User::ExternalAuthDisabled)
        end
      end
      context '認可プロバイダがSAMLサーバでない場合' do
        let(:access_token) {
          double("OmniAuth::AuthHash",
                 :provider => "psedo-saml",
                 :uid => "unique-value",
                 :info => double("OmniAuth::AuthHash::InfoHash")
                 )
        }
        it 'InvalidAuthProvider例外が発生すること' do
          lambda{subject}.should raise_error(User::InvalidAuthProvider)
        end
      end
    end
  end

end

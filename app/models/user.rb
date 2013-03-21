# -*- coding: utf-8 -*-
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  # :recoverable, :rememberable
  devise :database_authenticatable, :registerable,
         :trackable, :validatable, :omniauthable, :confirmable ,:authentication_keys => [:login]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :login, :email, :password, :password_confirmation, :remember_me, :agent_id, :confirmed_at
  attr_accessible :provider, :uid

  validates :login, :presence => true, :uniqueness => true

  # 認可プロバイダ識別子
  LDAP_IDENTIFIER = 'ldap'
  GOOGLE_IDENTIFIER = 'google'
  TWITTER_IDENTIFIER = 'twitter'
  FACEBOOK_IDENTIFIER = 'facebook'
  OPENAM_IDENTIFIER = 'openam'

  class InvalidAuthProvider < StandardError; end
  class ExternalAuthDisabled < StandardError; end

  # return user authenticate with LDAP
  # ==== Args
  # _access_token_ :: LDAPアクセストークン
  # _signed_in_resource_ :: RESERVED
  # ==== Return
  # Userオブジェクト
  # ==== Raise
  # InvalidAuthProvider :: 想定しないプロバイダによる認可のとき
  # ExternalAuthDisabled :: 設定で機能が無効化されているとき
  def self.find_for_ldap(access_token, signed_in_resource=nil)
    raise ExternalAuthDisabled, "currently disabled sign-in via #{access_token.provider}" unless SETTINGS['ldap_auth']['enable']
    raise InvalidAuthProvider, "illegal authorizer: #{access_token.provider}" unless access_token.provider == 'ldap'
    loginid = access_token.info.name
    uid = access_token.uid #DN
    User.destroy_all(:provider => LDAP_IDENTIFIER, :uid => uid)
    return authorized_user(LDAP_IDENTIFIER, loginid, uid, {:email=>access_token.info.email})
  end

  # create user authorized by google
  # ==== Args
  # _access_token_ :: openidアクセストークン
  # _signed_in_resource_ :: RESERVED
  # ==== Return
  # Userオブジェクト
  # ==== Raise
  # InvalidAuthProvider :: 想定しないプロバイダによる認可のとき
  # ExternalAuthDisabled :: 設定で機能が無効化されているとき
  def self.find_for_open_id(access_token, signed_in_resource=nil)
    raise ExternalAuthDisabled, "currently disabled sign-in via #{access_token.provider}" unless SETTINGS['external_auth']['enable']
    raise InvalidAuthProvider, "illegal authorizer: #{access_token.provider}" unless access_token.provider == 'google'
    loginid = access_token.info.email
    uid = access_token.uid
    return authorized_user(GOOGLE_IDENTIFIER, loginid, uid)
  end

  # create user authorized by twitter/facebook
  # ==== Args
  # _access_token_ :: oauthアクセストークン
  # _signed_in_resource_ :: RESERVED
  # ==== Return
  # Userオブジェクト
  # ==== Raise
  # InvalidAuthProvider :: 想定しないプロバイダによる認可のとき
  # ExternalAuthDisabled :: 設定で機能が無効化されているとき
  def self.find_for_oauth(access_token, signed_in_resource=nil)
    raise ExternalAuthDisabled, "currently disabled sign-in via #{access_token.provider}" unless SETTINGS['external_auth']['enable']
    case access_token.provider
    when 'twitter'
      return self.authorized_user(TWITTER_IDENTIFIER, "@" + access_token.info.nickname, access_token.uid)
    when 'facebook'
      return self.authorized_user(FACEBOOK_IDENTIFIER, access_token.info.name, access_token.uid)
    end
    raise InvalidAuthProvider, "illegal authorizer: #{access_token.provider}"
  end

  # create user authorized by openam
  # ==== Args
  # _access_token_ :: アクセストークン
  # _signed_in_resource_ :: RESERVED
  # ==== Return
  # Userオブジェクト
  # ==== Raise
  # InvalidAuthProvider :: 想定しないプロバイダによる認可のとき
  # ExternalAuthDisabled :: 設定で機能が無効化されているとき
  def self.find_for_saml(access_token, signed_in_resource=nil)
    raise ExternalAuthDisabled, "currently disabled sign-in via #{access_token.provider}" unless SETTINGS['external_auth']['enable']
    raise InvalidAuthProvider, "illegal authorizer: #{access_token.provider}" unless access_token.provider == 'openam'
    loginid = access_token.uid
    uid = loginid
    return authorized_user(OPENAM_IDENTIFIER, loginid, uid)
  end

  private

  # 認可されたユーザを取得する(存在しなければ新規登録もする)
  # ==== Args
  # _provider_ :: 認可プロバイダ名(String)
  # _loginid_ :: ログインユーザID(String) ※"@user"や"Yamada Kazuo"などのユーザ名
  # _uid_ :: ログインユーザ識別子(String)
  # _options_ :: ユーザ情報オプション(Hash)
  # ==== Return
  # Userオブジェクト
  # ==== Raise
  def self.authorized_user(provider, loginid, uid, options={})
    if user = User.where(:provider => provider, :uid => uid).first
      return user
    else
      param = {
        :login => loginid,
        :email => "#{uid.gsub('@','_')}@#{provider}.local",
        :password => random_password,
      }.merge(options).merge({
        :provider => provider,
        :uid => uid,
        :confirmed_at => Time.now
      })
      return User.create!(param)
    end
  end

  # 擬似ランダム文字列を生成
  # ==== Args
  # ==== Return
  # 半角英数字(40文字)からなるランダムな文字列
  # ==== Raise
  def self.random_password
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    password = ''
    40.times { |i| password << chars[rand(chars.size-1)] }
    return password
  end

end

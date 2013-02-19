# -*- coding:utf-8 -*-
class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  # Googleによる認可結果リダイレクトアクション
  # ==== Args
  # ==== Return
  # ==== Raise
  def google
    @user = User.find_for_open_id(request.env["omniauth.auth"], current_user)
    redirect_to_result('google')
  end

  # Twitterによる認可結果リダイレクトアクション
  # ==== Args
  # ==== Return
  # ==== Raise
  def twitter
    @user = User.find_for_oauth(request.env["omniauth.auth"], current_user)
    redirect_to_result('twitter')
  end

  # facebookによる認可結果リダイレクトアクション
  # ==== Args
  # ==== Return
  # ==== Raise
  def facebook
    @user = User.find_for_oauth(request.env["omniauth.auth"], current_user)
    redirect_to_result('facebook')
  end

  private

  # 共通リダイレクト処理
  # ==== Args
  # _provider_ :: 認可プロバイダ名(String)
  # ==== Return
  # ==== Raise
  def redirect_to_result(provider)
    if @user && @user.persisted?
      flash[:notice] =  I18n.t "devise.omniauth_callbacks.success", :kind => provider
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.#{provider}_data"] = request.env["omniauth.auth"]
      redirect_to :action => :index
    end
  end
end

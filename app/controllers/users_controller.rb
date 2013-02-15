class UsersController < Devise::SessionsController

  # SignOut後にAlertが表示されるのを回避するため
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  def create

    # ログイン名、パスワード入力チェック
    if params[:user][:email].blank? && params[:user][:password].blank?
      set_flash_message(:alert, :invalid)
      redirect_to(:action => :new)
      return
    end

    # ログイン名入力チェック
    if params[:user][:email].blank?
      set_flash_message(:alert, :invalid_login)
      redirect_to(:action => :new)
      return
    end

    # パスワード入力チェック
    if params[:user][:password].blank?
      set_flash_message(:alert, :invalid_password)
      redirect_to(:action => :new)
      return
    end

    # 本番用
    # super
    # 開発用
    user = User.find_by_email(params[:user][:email])
    warden.authenticate!(auth_options) if user.blank?
    sign_in(user, :bypass => true)
    respond_with user, :location => after_sign_in_path_for(user)

  end

end

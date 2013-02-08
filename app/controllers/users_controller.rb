class UsersController < Devise::SessionsController

  # SignOut後にAlertが表示されるのを回避するため
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end

  def index
    @users = User.all
  end

  def new
    super
  end

  def create

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

  end

end

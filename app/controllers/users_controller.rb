class UsersController < Devise::SessionsController

  # SignOut後にAlertが表示されるのを回避するため
  def after_sign_out_path_for(resource_or_scope)
p "after_sign_out_path_for"
    new_user_session_path
  end

  def index
p "index"
    @users = User.all
  end

  def new
p "new"
    super
  end

  def create
=begin
    @user = User.new(params[:user])
    respond_to do |format|
      if @user.save
        format.html { redirect_to users_path }
      else
        format.html { render new_users_path }
      end
    end
=end
p "create"
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

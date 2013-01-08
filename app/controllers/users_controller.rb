class UsersController < Devise::SessionsController

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
    @user = User.new(params[:user])
    respond_to do |format|
      if @user.save
        format.html { redirect_to users_path }
      else
        format.html { render new_users_path }
      end
    end
  end

end

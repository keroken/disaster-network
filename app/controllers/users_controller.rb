class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user, only: [:edit, :update]
  
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts
  end

  def new
    @user = User.new
  end
  
#  def create
#    @user = User.new(user_params)
#    if @user.save
#      flash[:success] = "Welcome to the Disaster Network App!"
#      redirect_to @user
#    else
#      render 'new'
#    end
#  end
  
  def create
      if env['omniauth.auth'].present?
          # Facebookログイン
          @user  = User.from_omniauth(env['omniauth.auth'])
          result = @user.save(context: :facebook_login)
          fb       = "Facebook"
      else
          # 通常サインアップ
          @user  = User.new(strong_params)
          result = @user.save
          fb       = ""
      end
      if result
          sign_in @user
          flash[:success] = "#{fb}ログインしました。" 
          redirect_to @user
      else
          if fb.present?
              redirect_to auth_failure_path
          else
              render 'new'
          end
      end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "Profile updated!"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end
  
  def logged_in_user
    redirect_to login_url, notice: 'Please log in.' unless logged_in?
  end
  
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end
  
end

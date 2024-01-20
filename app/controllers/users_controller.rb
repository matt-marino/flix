class UsersController < ApplicationController

  before_action :set_user, except: [:new]
  before_action :require_signin, except: [:new, :create]
  before_action :require_correct_user, only: [:edit, :update, :destroy]
  before_action :require_admin, only: [:destroy]

  def index
    @users = User.not_admins
  end

  def show
    @reviews = @user.reviews
    @favorite_movies = @user.favorite_movies
  end

  def new
    @user = User.new
  end

  def create
    byebug
    user = User.find_by(email: params[:email_or_username]) ||
      User.find_by(username: params[:email_or_username])
    if @user.save
      session[:user_id] = @user.id
      redirect_to @user, notice: "Thanks for signing up!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: "Account successfully updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    redirect_to root_url, status: :see_other,
      alert: "Account successfully deleted!"
  end

  private

  def set_user
    @user = User.find_by!(username: params[:id])
  end

  def user_params
    params.require(:user).
      permit(:name, :email, :password, :password_confirmation, :username)
  end

  def require_correct_user
    redirect_to root_url, status: :see_other unless current_user?(@user)
  end
end

class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save!
      session[:user_id] = @user.id
      redirect_to photos_path
    else
      render new
    end

  end

  def show
    @user = User.find_by_id(params[:id])
    @photos = @user.photos
  end

  def index
    @users = User.all
  end
  


  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar)
  end
end
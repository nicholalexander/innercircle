class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by_email(params[:login][:email])
    if @user && @user.authenticate(params[:login][:password])
      session[:user_id] = @user.id
      redirect_to photos_path
    else
      flash.now.alert = "Email or Password Invalid"
      render "new"
    end
  end

  def destroy
    session[:user_id] = nil
    session[:admin_id] = nil
    redirect_to root_url, notice: "logged out!"
  end

end
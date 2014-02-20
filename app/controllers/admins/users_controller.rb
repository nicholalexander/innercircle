class Admins::UsersController < ApplicationController

	def index
		@user = User.all
	end

	def edit
		@user = User.find(params[:id])
	end

	def update
		@user = User.find(params[:id])
		if @user.update_attributes(user_params)
			redirect_to admins_users_path
		else
			render 'edit'
		end
	end

	def destroy
		@user.find(params[:id]).destroy
	end


	private

	def user_params
		params.require(:user).permit(:name, :avatar, :email)
	end
end
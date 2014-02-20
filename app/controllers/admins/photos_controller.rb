class Admins::PhotosController < ApplicationController

	def index
		@photo = Photo.all
	end

	def edit
		@photo = Photo.find(params[:id])
	end

	def update
		@photo = Photo.find(params[:id])
		if @photo.update_attributes(photo_params)
				redirect_to admins_users_path
		else
			render 'edit'
		end
	end

	def destroy
		@photo.find(params[:id]).destroy
	end

	def photo_params
		params.require(:photo).permit(:image, :title, :description)
	end

end


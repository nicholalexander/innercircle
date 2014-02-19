class PhotosController < ApplicationController

  before_filter :authorize_user

  def index
    @photos = Photo.all
  end

  def new
    @photo = Photo.new
  end

  def create
    #binding.pry
    @photo = Photo.create( photo_params )
    @photo.user_id = current_user.id
    if @photo.save!
      redirect_to photos_path
    else
      render "new", notice: "Image did not save..."
    end
  end

  def show
    @photo = Photo.find(params[:id])
    @new_comment = Comment.new
    
    
  end


  private
  
  def photo_params
    params.require(:photo).permit(:image, :title, :description, :user_id)
  end

end

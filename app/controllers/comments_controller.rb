class CommentsController < ApplicationController
  respond_to :html, :js, :json

  def index

  end

  def create
    @photo = Photo.find_by_id(params[:photo_id])
    @comment = Comment.create(comment_params)
    @comment.user_id = current_user.id
    @comment.photo_id = params[:photo_id]
    @comment.save!
    # render 'photos/create', :formats => [:js]
  end

 private
  
  def comment_params
    params.require(:comment).permit(:text)
  end

end

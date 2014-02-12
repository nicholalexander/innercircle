class CommentsController < ApplicationController

  def create

    @comment = Comment.create(comment_params)
    @comment.user_id = current_user.id
    @comment.photo_id = params[:photo_id]

    if @comment.save!  
      redirect_to photo_path(params[:photo_id])
    end

  end


 private
  
  def comment_params
    params.require(:comment).permit(:text)
  end

end

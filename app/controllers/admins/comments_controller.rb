class Admins::CommentsController < ApplicationController
	def index
		@comment = Comment.all
	end

	def edit
		@comment = Comment.find(params[:id])
	end

	def update
		@comment = Comment.find(params[:id])
		if @comment.update_attributes(comment_params)
			redirect_to admins_users_path
		end
	end

	def destroy
		Comment.find(params[:id]).destroy
	end


	private

	def comment_params
		params.require(:comment).permit(:text)
	end
end
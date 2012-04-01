class CommentController < ApplicationController
	before_filter :signed_in_user, only: [:create, :destroy]

   def create
    @micropost = Micropost.find(params[:micropost_id])
    @comment = @micropost.comments.build(params[:comment])
    @comment.user = current_user
      respond_to do |format|
      @comment.save
           format.html { redirect_to current_user }
           format.js
      end
   end 
end

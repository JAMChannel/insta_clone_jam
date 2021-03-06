class CommentsController < ApplicationController
  before_action :require_login, only: %i[create edit update destroy]
  def edit
    @comment = current_user.comments.find(params[:id])
  end

  def update
    @comment = current_user.comments.find(params[:id])
    @comment.update(comment_update_params)
    # binding.pry
  end

  def create
    @comment = current_user.comments.build(comment_params)
    @comment.save
    # binding.pry
    UserMailer.with(user_from: current_user, user_to: @comment.post.user, comment: @comment).comment_post.deliver_later if @comment.save && @comment.post.user.notification_on_comment?

  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy!
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(post_id: params[:post_id])
  end

  def comment_update_params
    params.require(:comment).permit(:body)
    # すでにpost_idは存在している
  end
end

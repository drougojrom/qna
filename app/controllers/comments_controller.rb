class CommentsController < ApplicationController

  before_action :set_commentable, only: [:create]
  before_action :authenticate_user!, only: [:create]

  authorize_resource

  def create
    @comment = @commentable.make_comment(current_user, comment_params[:body])
    render json: comment_format_json
  end

  private 

  def comment_format_json
    data = {
      class: @commentable.class.name.downcase,
      id: @commentable.id,
      body: @comment.body,
      user_email: @comment.user.email,
      user_id: @comment.user.id
    }
    ActionCable.server.broadcast("comments_for_#{@comment.commentable_type == 'Question' ? @commentable.id : @commentable.question_id}",
                                 data)
    data
  end

  def set_commentable
    @commentable = Question.find(params[:question_id]) if params[:question_id].present?
    @commentable = Answer.find(params[:answer_id]) if params[:answer_id].present?
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end

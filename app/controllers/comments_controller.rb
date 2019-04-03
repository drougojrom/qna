class CommentsController < ApplicationController

  before_action :set_commentable, only: [:create]

  def create
    @comment = @commentable.make_comment(current_user, comment_params[:body])
    render json: comment_format_json
  end

  def comment_format_json
    data = {
      class: @commentable.class.name.downcase,
      id: @commentable.id,
      body: @comment.body,
      user_email: @comment.user.email,
      user_id: @comment.user.id
    }
    ActionCable.server.broadcast('comments',
                                 data)
    return data
  end

  private 

  def set_commentable
    @commentable = Question.find(params[:question_id]) if params[:question_id].present?
    @commentable = Answer.find(params[:answer_id]) if params[:answer_id].present?
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end

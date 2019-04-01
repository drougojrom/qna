module Commenting
  extend ActiveSupport::Concern

  included do 
    before_action :set_commentable, only: [:make_comment]
    respond_to :json
  end

  def make_comment
    @comment = @commentable.make_comment(current_user, comment_params[:body])
    render json: format_json
  end

  def format_json
    {
      class: @commentable.class.name.downcase,
      id: @commentable.id,
      body: @comment.body,
      user: @comment.user.email
    }
  end

  private 

  def set_commentable
    @commentable = controller_name.classify.constantize.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end

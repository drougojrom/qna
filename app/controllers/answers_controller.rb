class AnswersController < ApplicationController

  include Voting

  before_action :authenticate_user!
  before_action :authored?, only: %i[update destroy]

  after_action :publish_answer, only: [:create]

  authorize_resource

  def edit
  end

  def update
    answer.update(answer_params)
  end

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save 
  end

  def destroy
    answer.destroy
  end

  def right_answer
    answer.make_right_answer(current_user, true)
  end

  def not_right_answer
    if answer.make_right_answer(current_user, false)
      render :right_answer
    else
      head 403
    end
  end

  private

  helper_method :answer, :question, :comment

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url])
  end

  def answer
    @answer ||= params[:id] ? Answer.with_attached_files.find(params[:id]) : Answer.new
  end

  def question
    @question ||= params[:question_id] ? Question.find(params[:question_id]) : answer.question
  end

  def comment
    @comment ||= Comment.new
  end

  def authored?
    unless current_user.author_of?(answer)
      redirect_to answer.question, notice: "You aren't an author of that question"
    end
  end

  def publish_answer
    return if answer.errors.any?
    ActionCable.server.broadcast(
      "question_#{@answer.question.id}", 
      answer: answer
    )
  end
end

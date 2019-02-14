class AnswersController < ApplicationController
  before_action :authenticate_user!  
  before_action :authored?, only: %i[update destroy]

  def edit
  end

  def update
    if answer.update(answer_params)
      redirect_to question
    else
      render :edit
    end
  end

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def destroy
    answer.destroy
    respond_to do |f|
      f.js
    end
  end

  private

  helper_method :answer, :question

  def answer_params
    params.require(:answer).permit(:body)
  end

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new
  end

  def question
    @question ||= params[:question_id] ? Question.find(params[:question_id]) : answer.question 
  end

  def authored?
    unless current_user.author_of?(answer)
      redirect_to answer.question, notice: "You aren't an author of that question"
    end
  end
end

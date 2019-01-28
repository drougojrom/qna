class AnswersController < ApplicationController

  before_action :find_question, only: %i[new create]

  def new
  end

  def edit
  end

  def update
  end

  def create
    answer = @question.answers.new(answer_params)
    if answer.save
      redirect_to @question
    else
      render :new
    end
  end

  def destroy
    answer.destroy
    redirect_to questions_path
  end

  private

  helper_method :answer

  def find_question
    @question = Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new
  end
end

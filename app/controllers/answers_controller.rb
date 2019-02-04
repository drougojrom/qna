class AnswersController < ApplicationController

  before_action :find_question, only: %i[new create]
  before_action :answer, only: %i[show new edit]

  def new
  end

  def show

  end

  def edit
  end

  def update
    if answer.update(answer_params)
      redirect_to answer
    else
      render :edit
    end
  end

  def create
    answer = @question.answers.new(answer_params)
    if answer.save
      redirect_to answer, notice: 'Your answer successfully created'
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

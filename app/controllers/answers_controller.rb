class AnswersController < ApplicationController

  before_action :authenticate_user!  
  before_action :find_question, only: %i[new create]
  before_action :authored?, only: %i[update destroy]

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
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user
    if @answer.save
      redirect_to @question, notice: 'Your answer successfully created'
    else
      render :new
    end
  end

  def destroy
    answer.destroy
    redirect_to questions_path, notice: 'Your answer was deleted'
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

  def authored?
    unless current_user.is_author?(answer)
      redirect_to answer.question, notice: "You aren't an author of that question"
    end
  end
end

class Api::V1::QuestionsController < Api::V1::BaseController
  # TODO: remove later
  skip_authorization_check

  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    @question = Question.find(params[:id])
    render json: @question
  end
end

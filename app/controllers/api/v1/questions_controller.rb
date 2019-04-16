class Api::V1::QuestionsController < Api::V1::BaseController
  # TODO: remove later
  skip_authorization_check

  def index
    @questions = Question.all
    render json: @questions.to_json(include: :answers)
  end
end

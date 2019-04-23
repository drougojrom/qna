class Api::V1::AnswersController < Api::V1::BaseController

  def index
    render json: question.answers
  end

  def show
    render json: answer
  end

  private

  helper_method :answer, :question

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url])
  end

  def answer
    @answer ||= params[:id] ? Answer.with_attached_files.find(params[:id]) : Answer.new
  end

  def question
    @question ||= params[:question_id] ? Question.find(params[:question_id]) : answer.question
  end
end

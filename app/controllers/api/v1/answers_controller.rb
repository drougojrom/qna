class Api::V1::AnswersController < Api::V1::BaseController

  load_and_authorize_resource

  def index
    render json: question.answers
  end

  def show
    render json: answer
  end

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_resource_owner
    render json: @answer if @answer.save 
  end

  def destroy
    answer.destroy
  end

  def update
    answer.update(answer_params)
  end

  private

  helper_method :answer, :question

  def answer_params
    params.require(:answer).permit(:body)
  end

  def answer
    @answer ||= params[:id] ? Answer.with_attached_files.find(params[:id]) : Answer.new
  end

  def question
    @question ||= params[:question_id] ? Question.find(params[:question_id]) : answer.question
  end
end

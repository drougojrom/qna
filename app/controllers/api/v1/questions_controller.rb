class Api::V1::QuestionsController < Api::V1::BaseController

  load_and_authorize_resource

  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    @question = Question.find(params[:id])
    render json: @question
  end

  def create
    @question = current_resource_owner.questions.new(question_params)
    render json: @question if @question.save
  end

  def update
    question.update(question_params)
  end

  def destroy
    question.destroy
  end

  private

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body)
  end

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end
end

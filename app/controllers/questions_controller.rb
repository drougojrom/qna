class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :authored?, only: [:update, :destroy]

  def index
    @questions = Question.all
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save 
      redirect_to @question, notice: 'Your question successfully created'
    else
      render :new
    end
  end

  def update
    question.update(question_params)
  end

  def destroy
    question.destroy
    redirect_to questions_path, notice: 'Your question was deleted'
  end

  def delete_file
    file = ActiveStorage::Attachment.find_by(id: params[:id])
    file.purge
    redirect_to questions_path, notice: 'Deleted'
  end

  private

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  def answer
    @answer = Answer.new
  end

  helper_method :question, :answer

  def question_params
    params.require(:question).permit(:title, :body, files: [])
  end

  def authored?
    unless current_user.author_of?(question)
      redirect_to question, notice: "You aren't an author of that question"
    end
  end
end

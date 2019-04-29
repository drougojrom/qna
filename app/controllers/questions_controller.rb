class QuestionsController < ApplicationController

  include Voting

  before_action :authenticate_user!, except: [:index, :show]
  before_action :authored?, only: [:update, :destroy]
  after_action :publish_question, only: [:create]

  authorize_resource

  def index
    @questions = Question.all
  end

  def show
    answer.links.new
  end

  def new
    question.links.build
    question.reward = Reward.new
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

  private

  helper_method :question, :answer, :comment

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  def answer
    @answer ||= Answer.new
  end

  def comment
    @comment ||= Comment.new
  end

  def question_params
    params.require(:question).permit(:title, :body,
                                     files: [], links_attributes: [:name, :url, :_destroy],
                                     reward_attributes: [:title, :image])
  end

  def authored?
    unless current_user.author_of?(question)
      redirect_to question, notice: "You aren't an author of that question"
    end
  end

  def publish_question
    return if question.errors.any?
    ActionCable.server.broadcast(
        'questions',
        question: question
    )
  end
end

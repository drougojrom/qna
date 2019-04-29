class SubscriptionsController < ApplicationController

  authorize_resource

  def create
    @subscription = question.add_subscription(current_user)
  end

  def destroy
    question.remove_subscription(current_user)
  end

  private

  helper_method :question

  def question
    @question = Question.find(params[:question_id]) if params[:question_id].present?
  end
end

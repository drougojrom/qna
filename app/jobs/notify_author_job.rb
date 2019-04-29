class NotifyAuthorJob < ApplicationJob
  queue_as :default

  def perform(question)
    question.subscriptions.each do |subscription|
      NotificationMailer.notification(question, subscription.user).deliver_later
    end
  end
end

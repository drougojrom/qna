class NotifyAuthorJob < ApplicationJob
  queue_as :default

  def perform(answer)
    answer.send_notification_to_subscribers
  end
end

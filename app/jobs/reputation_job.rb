class ReputationJob < ApplicationJob
  queue_as :default

  def perform(object)
    Services::Reputation.calculate(object)
    sleep(3)
  end
end

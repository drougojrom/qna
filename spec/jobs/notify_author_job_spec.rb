require 'rails_helper'

RSpec.describe NotifyAuthorJob, type: :job do
  let(:question) { create :question }
  let!(:answer) { create :answer, question: question }

  it 'sends notification' do
    NotifyAuthorJob.perform_now(answer.question)
    expect(answer).to receive(:send_notification_to_subscribers)
    answer.send_notification_to_subscribers
  end
end

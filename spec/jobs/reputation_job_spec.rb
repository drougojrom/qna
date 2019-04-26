require 'rails_helper'

RSpec.describe ReputationJob, type: :job do
  let(:question) { build(:question) }

  it 'calls ReputationJob' do
    expect(Services::Reputation).to receive(:calculate).with(question)
    question.save!
    ReputationJob.perform_now(question)
  end
end

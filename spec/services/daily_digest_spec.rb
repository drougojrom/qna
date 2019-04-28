require 'rails_helper'

RSpec.describe Services::DailyDigest do
  let(:users) { create_list :user, 3 }
  let(:questions) { create_list :question, 3 }

  it 'sends daily digest to all users' do
    User.send_daily_digest
  end
end

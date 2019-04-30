require 'rails_helper'

RSpec.describe Services::DailyDigest do
  it 'sends daily digest to all users' do
    subject.send_digest
  end
end

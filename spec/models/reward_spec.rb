require 'rails_helper'

RSpec.describe Reward, type: :model do
  describe 'associations' do
    it { should have_one :user }
    it { should belong_to :question }
  end

  describe 'validations' do
    it { should validate_presence_of :title }
  end
end

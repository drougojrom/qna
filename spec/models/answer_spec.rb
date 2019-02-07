require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'ActiveRecord validations' do
    it { should belong_to :question }
    it { should belong_to :user }
  end

  describe 'ActiveModel validations' do
    it { should validate_presence_of :body }
  end
end

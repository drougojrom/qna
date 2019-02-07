require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'ActiveRecord validations' do
    it { should have_many(:questions) }
    it { should have_many(:answers) }
  end

  describe 'ActiveModel validations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end

  let(:question) { create(:question) }

  it 'user is the author of question' do
    expect(question.user.is_author?(question)).to be(true)
  end

  context 'user is not the author of question' do
    let!(:new_user) { create(:user) }
    it 'user should not count as an author' do
      expect(new_user.is_author?(question)).not_to be(true)
    end
  end
end

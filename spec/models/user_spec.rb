require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:questions) }
    it { should have_many(:answers) }
  end

  describe 'validations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end

  let(:user) { create(:user) }
  let(:question) { create :question, user: user }

  it 'user is the author of question' do
    expect(user).to be_author_of(question)
  end

  context 'user is not the author of question' do
    let!(:new_user) { create(:user) }
    it 'user should not count as an author' do
      expect(new_user).to_not be_author_of(question)
    end
  end
end

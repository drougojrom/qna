require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:questions) }
  it { should have_many(:answers) }

  context 'is author' do
    let!(:question) { create(:question) }

    it 'user is the author of question' do
      expect(question.user.is_author?(question)).to be(true)
    end
  end
end

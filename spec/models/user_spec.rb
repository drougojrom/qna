require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:questions) }
    it { should have_many(:answers) }
    it { should have_many(:authorizations).dependent(:destroy) }
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

  describe '.find_for_oauth' do
    let!(:user) { create :user }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123') }
    let(:service) { double('Services::FindForOauth') }

    it 'calls Services::FindForOauth' do
      expect(Services::FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end
end

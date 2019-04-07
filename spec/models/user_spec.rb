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

  describe '.find_for_oauth' do
    let!(:user) { create :user }
    let!(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123') }

    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'github', uid: '123')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context 'user does not have an authorization' do
      context 'user already exists' do
        let!(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123', info: { email: user.email }) }
        it 'does not create a new user' do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by 1
        end

        it 'creates an authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first
          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context 'user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123', info: { email: 'new@email.com' }) }

        it 'creates a new user' do
          expect { User.find_for_oauth(auth) }.to change(User, :count).by 1
        end

        it 'returns a new user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'fills users email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info[:email]
        end

        it 'creates an authorization' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'creates an authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first
          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end
end

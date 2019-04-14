require 'rails_helper'

RSpec.describe AnswerPolicy, type: :policy do
  let(:user) { User.new }

  subject { AnswerPolicy }

  permissions :update? do
    it 'grants access if user is admin' do
      expect(subject).to permit(User.new(admin: true), create(:answer))
    end

    it 'grants access if user is an author' do
      expect(subject).to permit(user, create(:answer, user: user))
    end

    it 'denies access if user is not an author' do
      expect(subject).to_not permit(user, create(:answer, user: User.new))
    end
  end
end

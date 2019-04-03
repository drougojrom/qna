require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should validate_presence_of :body }
  it { should belong_to :user }
  it { should belong_to(:commentable).optional }

  let(:question) { create(:question) }

  describe '#create' do
    context 'create comment for question' do
      it 'increases comments count for the question' do
        expect { question.comments.create(user: question.user, body: "123") }.to change(question.comments, :count).by 1
      end
    end
  end
end

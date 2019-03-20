require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should validate_numericality_of :value }
  it { should delegate_method(:rating).to(:votable) }

  let(:question) { create(:question) }

  describe 'validate uniqueness' do
    it 'should validate uniquesness of name' do
      Vote.create(user: question.user, value: 1, votable: question)
      vote = Vote.new(user: question.user, value: 1, votable: question)
      expect(vote).not_to be_valid
    end
  end

  describe '#create' do
    context 'vote for' do
      it 'increase question rating' do
        expect { question.votes.create(user: question.user, value: 1) }.to change(question, :rating).by 1
      end
    end
    context 'vote against' do
      it 'decrease question rating' do
        expect { question.votes.create(user: question.user, value: -1) }.to change(question, :rating).by(-1)
      end
    end
  end

  describe '#destroy' do
    context 'vote for' do
      let!(:vote) { question.votes.create(user: question.user, value: 1) }
      it 'decrease question rating' do
        expect { vote.destroy }.to change(question, :rating).by(-1)
      end
    end
    context 'vote against' do
      let!(:vote) { question.votes.create(user: question.user, value: -1) }
      it 'increase question rating' do
        expect { vote.destroy }.to change(question, :rating).by 1
      end
    end
  end
end

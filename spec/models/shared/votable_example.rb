require 'rails_helper'

shared_examples 'votable' do
  it { should have_many(:votes).dependent(:delete_all) }

  let(:votable) { create described_class.to_s.underscore.to_sym }
  let(:user) { create :user }
  let(:users) { create_list(:user, 2) }


  describe 'vote_for' do
    context 'not yet voted' do
      it 'creates a vote in db' do
        expect { votable.vote_for user }.to change(Vote, :count).by(1)
      end
      it 'increases votable rating' do
        expect {
          votable.vote_for(user)
          votable.reload
        }.to change(votable, :rating).by(1)
      end
    end
    context 'already voted' do
      before do
        votable.vote_for user
        votable.reload
      end
      it 'does not create a vote in db' do
        expect { votable.vote_for user }.to raise_error ActiveRecord::RecordInvalid
      end
    end
  end

  describe 'vote_against' do
    context 'not yet voted' do
      it 'creates a vote in db' do
        expect { votable.vote_against user }.to change(Vote, :count).by(1)
      end
      it 'increases votable rating' do
        expect {
          votable.vote_against(user)
          votable.reload
        }.to change(votable, :rating).by(-1)
      end
    end
    context 'already voted' do
      before do
        votable.vote_for user
        votable.reload
      end
      it 'does not create a vote in db' do
        expect { votable.vote_against user }.to raise_error ActiveRecord::RecordInvalid
      end
    end
  end

  describe 'vote_revoke' do
    context 'not yet voted' do
      it 'does not create a vote in db' do
        expect { votable.vote_revoke user }.to_not change(Vote, :count)
      end
    end
    context 'already voted' do
      before do
        votable.vote_for user
        votable.reload
      end
       it 'decreases votable rating' do
        expect {
          votable.vote_revoke(user)
          votable.reload
        }.to change(votable, :rating).by(-1)
      end
    end
  end

  describe 'user vote' do
    it 'finds a users vote' do
      vote = votable.user_vote(user)
      expect(vote.user).to eq user
    end
  end

  describe 'rating' do
    it 'returns rating' do
      users.each do |user|
        votable.vote_for(user)
      end
      votable.reload
      expect(votable.rating).to eq 2
    end
  end
end

require 'rails_helper'

shared_examples 'voting' do

  let(:votable_class) { described_class.controller_name.singularize.underscore.to_sym }
  let(:votable) { create votable_class }

  describe 'POST #revoke' do
    context 'unauthorized user' do
      let!(:vote) { create :vote, votable: votable, value: 1 }
      it 'response 401 unauthorized' do
        post :vote_revoke, params: {id: votable.id}, format: :json
        expect(response).to have_http_status(401)
      end

      it 'not change votes count in db' do
        expect { post :vote_revoke, params: {id: votable.id} , format: :json }.to_not change(Vote, :count)
      end

      it 'not increases votable rating' do
        post :vote_revoke, params: {id: votable.id}, format: :json
        expect { votable.reload }.to_not change(votable, :rating)
      end
    end

    context 'authorized user on existing vote' do
      let!(:vote) { create :vote, votable: votable, value: 1 }
      before { sign_in vote.user }

      it 'decreases rating' do
        post :vote_revoke, params: {id: votable.id}, format: :json
        expect { votable.reload }.to change(votable, :rating).by(-1)
      end

      it 'delete vote from db' do
        votable = vote.votable
        expect { post :vote_revoke, params: { id: votable.id }, format: :json }.to change(Vote, :count).by(-1)
      end
    end
  end

  describe 'POST #vote_for' do
    context 'unauthorized user' do
      let!(:vote) { create :vote, votable: votable, value: 1 }
      it 'response 401 unauthorized' do
        post :vote_for, params: {id: votable.id}, format: :json
        expect(response).to have_http_status(401)
      end

      it 'not change votes count in db' do
        expect { post :vote_for, params: {id: votable.id} , format: :json }.to_not change(Vote, :count)
      end

      it 'increases votable rating' do
        post :vote_for, params: {id: votable.id}, format: :json
        expect { votable.reload }.to_not change(votable, :rating)
      end
    end

    context 'authorized user votes' do
      before { sign_in votable.user }

      it 'increases rating' do
        post :vote_for, params: {id: votable.id}, format: :json
        expect { votable.reload }.to change(votable, :rating).by 1
      end

      it 'add vote to db' do
        expect { post :vote_for, params: { id: votable.id }, format: :json }.to change(Vote, :count).by(1)
      end
    end

    context 'vote already exists' do
      before do
        create(:vote, votable: votable, user: user, value: 1)
        sign_in user
      end

      it 'not increases votable rating' do
        post :vote_for, params: {id: votable.id}, format: :json
        expect { votable.reload }.to_not change(votable, :rating)
      end

      it 'not change votes count in db' do
        expect { post :vote_for, params: {id: votable.id} , format: :json }.to_not change(Vote, :count)
      end
    end
  end

  describe 'POST #vote_against' do
    context 'unauthorized user' do
      it 'response 401 unauthorized' do
        post :vote_against, params: {id: votable.id}, format: :json
        expect(response).to have_http_status(401)
      end

      it 'not change votes count in db' do
        expect { post :vote_against, params: {id: votable.id} , format: :json }.to_not change(Vote, :count)
      end

      it 'not increases votable rating' do
        post :vote_against, params: {id: votable.id}, format: :json
        expect { votable.reload }.to_not change(votable, :rating)
      end
    end

    context 'authorized user votes' do
      before { sign_in votable.user }

      it 'decreases rating' do
        post :vote_against, params: {id: votable.id}, format: :json
        expect { votable.reload }.to change(votable, :rating).by(-1)
      end

      it 'adds vote to db' do
        expect { post :vote_against, params: { id: votable.id }, format: :json }.to change(Vote, :count).by(1)
      end
    end
  end
end

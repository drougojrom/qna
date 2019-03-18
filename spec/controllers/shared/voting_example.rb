require 'rails_helper'

shared_examples 'voting' do

  let(:votable_class) { described_class.controller_name.singularize.underscore.to_sym }
  let(:votable) { create votable_class }

  describe 'POST #revoke' do
    context 'authorized user' do
      context 'on existing' do
        context 'positive vote' do
          let!(:vote) { create :vote }
          before { sign_in vote.user }
          it 'decreases rating' do
            votable = vote.votable
            post :vote_revoke, params: {id: votable.id}, format: :json
            expect { votable.reload }.to change(votable, :rating).by(-1)
          end
        end
      end
    end
  end

end

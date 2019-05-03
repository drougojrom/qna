require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do

  let(:question) { create(:question) }

  describe 'POST #create' do
    let!(:user) { create(:user) }

    context 'user is the author of question' do
      before { log_in(user) }

      it 'increases the number of subscriptions' do
        expect { post :create, params: { question_id: question.id }, format: :js}.to change(Subscription, :count).by(1)
      end

      it 'adds subscription to author of the question' do
        expect { post :create, params: { question_id: question.id }, format: :js}.to change(user.subscriptions, :count).by(1)
      end
    end

    context 'user is not the author of question' do
      let!(:question) { create(:question) }
      let!(:new_user) { create(:user) }
      before { log_in(new_user) }

      it 'allows to subscribe to question' do
        expect { post :create, params: { id: question.id }, format: :js}.to change(Subscription, :count).by(1)
      end

      it 'adds subscription to another user' do
        expect { post :create, params: { question: attributes_for(:question) }, format: :js}.to change(new_user.subscriptions, :count).by(1)
      end
    end
  end

  describe 'PATCH #unsubscribe' do
    let!(:question) { create(:question) }

    context 'user is the author of question' do
      before do
        log_in(question.user)
        patch :subscribe, params: { id: question.id }, format: :js
      end

      it 'decreases the number of subscriptions' do
        expect { patch :unsubscribe, params: { id: question.id }, format: :js}.to change(Subscription, :count).by(-1)
      end

      it 'removes subscription from the author of question' do
        expect { patch :unsubscribe, params: { id: question.id }, format: :js}.to change(question.user.subscriptions, :count).by(-1)
      end
    end

    context 'user is not the author of question' do
      let!(:new_user) { create(:user) }
      before do
        log_in(new_user)
        patch :subscribe, params: { id: question.id }, format: :js
      end

      it 'decreases the number of subscriptions' do
        expect { patch :unsubscribe, params: { id: question.id }, format: :js}.to change(Subscription, :count).by(-1)
      end

      it 'removes subscription from the new user' do
        expect { patch :unsubscribe, params: { id: question.id }, format: :js}.to change(new_user.subscriptions, :count).by(-1)
      end
    end
  end
end

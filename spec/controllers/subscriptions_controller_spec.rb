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
        expect { post :create, params: { question_id: question.id }, format: :js}.to change(Subscription, :count).by(1)
      end

      it 'adds subscription to another user' do
        expect { post :create, params: { question_id: question.id }, format: :js}.to change(new_user.subscriptions, :count).by(1)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:user) { create :user }
    let!(:subscription) { create :subscription, question: question, user: user }

    context 'user is the author of question' do

      before do
        log_in(user)
      end

      it 'decreases the number of subscriptions' do
        expect { delete :destroy, params: { id: subscription.id,
                                            question_id: question.id },
                        format: :js}.to change(Subscription, :count).by(-1)
      end

      it 'removes subscription from the author of question' do
        expect { delete :destroy, params: { id: subscription.id,
                                            question_id: question.id },
                        format: :js}.to change(user.subscriptions, :count).by(-1)
      end
    end

    context 'user is not the author of question' do
      let!(:new_user) { create(:user) }
      let!(:user) { create :user }
      let!(:subscription) { create :subscription, question: question, user: user }
      before do
        log_in(new_user)
        post :create, params: { question_id: question.id }, format: :js
      end

      it 'decreases the number of subscriptions' do
        expect { delete :destroy, params: { id: subscription.id,
                                            question_id: question.id },
                        format: :js}.to change(Subscription, :count).by(-1)
      end

      it 'removes subscription from the new user' do
        expect { delete :destroy, params: { id: subscription.id,
                                            question_id: question.id },
                        format: :js}.to change(new_user.subscriptions, :count).by(-1)
      end
    end
  end
end

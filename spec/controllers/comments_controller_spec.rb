require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let(:question) { create :question }
  let(:user) { create :user }  

  describe 'POST #create' do
    before { log_in question.user }
    context 'with valid attributes' do
      it 'saves a new comment into db' do
        expect { post :create, params: { question_id: question.id,
                                         comment: attributes_for(:comment) }, format: :js }.to change(question.comments, :count).by 1
      end

      it 'adds the comment to the question' do
        post :create, params: { question_id: question.id,
                                comment: attributes_for(:comment) }, format: :js
        expect(response).to have_http_status(200)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question.id,
                                         comment: attributes_for(:comment, :invalid) }, format: :js }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  context 'not authenticated user tries to post a comment' do
    before { post :create, params: { question_id: question.id,
                                     comment: attributes_for(:comment) }, format: :js }
    it "render 403" do
      expect(response.status).to eq(401)
    end
  end
end

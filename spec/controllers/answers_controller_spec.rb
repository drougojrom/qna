require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create :answer, question: question }

  describe 'GET #new' do
    before { get :new, params: { question_id: question.id } }

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { get :edit, params: {question_id: answer.question.id, id: answer}}

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      it 'saves a new answer into db' do
        expect { post :create, params: { question_id: question.id,
                                         answer: attributes_for(:answer) } }.to change(Answer, :count).by(1)
      end

      it 'redirects to question' do
        post :create, params: { question_id: answer.question.id,
                                answer: attributes_for(:answer) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question.id,
                                         answer: attributes_for(:answer, :invalid) } }.to_not change(Answer, :count)
      end

      it 'renders new' do
        post :create, params: { question_id: answer.question.id,
                                answer: attributes_for(:answer, :invalid) }
        expect(response).to render_template :new
      end
    end
  end
end

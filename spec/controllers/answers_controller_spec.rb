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

  describe 'GET #show' do
    before { get :show, params: { id: answer }}

    it 'renders show view' do
      expect(response).to render_template :show
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
                                         answer: attributes_for(:answer) } }.to change(question.answers, :count).by(1)
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

  describe 'PATCH #update' do
    context 'with valid attributes' do
      it 'assigns requested answer to @answer' do
        patch :update, params: { id: answer, answer: attributes_for(:answer) }
        expect(assigns(:answer)).to eq answer
      end
      it 'changes answers attributes' do
        patch :update, params: { id: answer, answer: { body: "New Body" }}
        answer.reload

        expect(answer.body).to eq "New Body"
      end
      it 'redirects to updated answer' do
        patch :update, params: { id: answer, answer: { body: "New Body" }}
        expect(response).to redirect_to answer
      end
    end

    context 'with invalid attributes' do
      before { patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) } }

      it 'does not change the question' do
        answer.reload

        expect(answer.body).to eq "MyText"
      end

      it 'renders edit' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question) }
    let!(:answer) { create :answer, question: question}

    it 'deletes the answer' do
      expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1) 
    end

    it 'redirects to questions index' do
      delete :destroy, params: { id: answer }
      expect(response).to redirect_to questions_path
    end
  end
end

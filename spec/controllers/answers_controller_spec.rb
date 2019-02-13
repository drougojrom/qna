require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }  
  let(:question) { create(:question) }
  let(:answer) { create :answer, question: question, user: user }

  describe 'GET #edit' do
    before { log_in(answer.user) }
    before { get :edit, params: {question_id: answer.question.id, id: answer}}

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { log_in(user) }    
    context 'with valid attributes' do
      it 'saves a new answer into db' do
        expect { post :create, params: { question_id: question.id,
                                         answer: attributes_for(:answer) }, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'adds an answer to the user' do
        expect { post :create, params: { question_id: question.id,
                                         answer: attributes_for(:answer)}, format: :js }.to change(user.answers, :count).by(1)
      end

      it 'redirects to question' do
        post :create, params: { question_id: answer.question.id,
                                answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, params: { question_id: question.id,
                                         answer: attributes_for(:answer, :invalid) }, format: :js }.to_not change(Answer, :count)
      end

      it 'renders question' do
        post :create, params: { question_id: answer.question.id,
                                answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :create
      end
    end
  end

  describe 'PATCH #update' do
    context 'user is the author of answer' do
      before { log_in(answer.user) }

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
        before { patch :update, params: { id: answer,
                                          answer: attributes_for(:answer, :invalid) } }

        it 'does not change the question' do
          answer.reload
          expect(answer.body).to eq "MyText"
        end

        it 'renders edit' do
          expect(response).to render_template :edit
        end
      end
    end

    context 'user is not an author of the answer' do
      let!(:new_user) { create(:user) }
      before { log_in(new_user) } 

      it 'does not change answers attributes' do
        patch :update, params: { id: answer, answer: { body: "New Body" }}
        answer.reload

        expect(answer.body).not_to eq "New Body"
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question) }
    let!(:answer) { create :answer, question: question, user: user }

    context 'user is the author of answer' do
      before { log_in(answer.user) }    

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer } }.to change(Answer, :count).by(-1) 
      end

      it 'redirects to questions index' do
        delete :destroy, params: { id: answer }
        expect(response).to redirect_to questions_path
      end
    end

    context 'user is not the author of answer' do
      let!(:new_user) { create(:user) }
      before { log_in(new_user) } 

      it 'does not delete the answer' do
        expect { delete :destroy, params: { id: answer } }.not_to change(Answer, :count)
        expect(response).to redirect_to question
      end
    end
  end
end

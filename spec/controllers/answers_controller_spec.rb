require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }  
  let(:question) { create(:question) }
  let(:answer) { create :answer, question: question, user: user }
  
  it_behaves_like 'voting'

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

      it 'renders create template' do
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

      it 'renders create template' do
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
          patch :update, params: { id: answer, answer: attributes_for(:answer) }, format: :js
          expect(assigns(:answer)).to eq answer
        end

        it 'changes answers attributes' do
          patch :update, params: { id: answer, answer: { body: "New Body" }}, format: :js
          answer.reload

          expect(answer.body).to eq "New Body"
        end

        it 'redirects to updated answer' do
          patch :update, params: { id: answer, answer: { body: "New Body" }}, format: :js
          expect(response).to render_template :update
        end
      end

      context 'with invalid attributes' do
        before { patch :update, params: { id: answer,
                                          answer: attributes_for(:answer, :invalid) }, format: :js }

        it 'does not change the question' do
          answer.reload
          expect(answer.body).to eq "MyText"
        end

        it 'renders edit' do
          expect(response).to render_template :update
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
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(Answer, :count).by(-1) 
      end

      it 'redirects to questions index' do
        delete :destroy, params: { id: answer }, format: :js
        expect(response).to render_template :destroy
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

  describe 'PATCH #right_answer' do
    context 'user is the author of question' do
      let!(:question) { create(:question) }
      let!(:answer) { create :answer, question: question, user: user }
      before { log_in(answer.question.user) }
      before { patch :right_answer, params: {id: answer}, format: :js }

      context 'answer is not the right one' do
        it 'makes the answer right' do
          expect(response).to render_template :right_answer
        end

        it 'assigns the answer to question' do
          expect(assigns(:answer).question.right_answer).to eq answer
        end

        it 'just one right answer' do
          expect(question.answers.where(right_answer: true).count).to eq 1
        end

        it 'sets right answer flag to true' do
          expect(assigns(:answer).right_answer).to eq true
        end
      end
    end

    context 'user is not the author of question' do
      before { patch :right_answer, params: {id: answer}, format: :js }

      it 'does not change the right answer for question' do
        sign_in user
        question.reload
        expect(question.right_answer).to_not eq answer
      end
    end
  end

  describe 'PATCH #not_right_answer' do
    context 'user is the author of question' do
      let!(:question) { create :question }
      let!(:answer) { create :answer, question: question, user: user }
      before { log_in(answer.question.user) }
      before { patch :not_right_answer, params: {id: answer}, format: :js }

      it 'renders right answer' do
        expect(response).to render_template :right_answer
      end

      it 'set answers flag to false' do
        expect(assigns(:answer).right_answer).to eq false
      end

      it 'no right answers' do
        expect(assigns(:answer).question.right_answer).to eq nil
      end
    end
  end

  context 'user is not the author of question' do
    before { log_in user }
    before { patch :not_right_answer, params: {id: answer}, format: :js }

    it "render 403" do
      expect(response.status).to eq(403)
    end
  end
end

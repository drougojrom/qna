require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create(:user) }
  before { log_in(user) }

  describe 'GET #index' do
    let!(:questions) { create_list(:question, 3) }
    before { get :index }

    it 'populates an array of all questions' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before { get :show, params: { id: question }}

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    before { log_in(user) }
    before { get :new }

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    before { log_in(user) }    
    before { get :edit, params: { id: question }}

    it 'renders edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    before { log_in(user) }

    context 'with valid attributes' do
      it 'saves a new question into db' do
        expect { post :create, params: { question: attributes_for(:question) }}.to change(Question, :count).by(1)
      end

      it 'redirects to show' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
      end
    end

    it 'adds a question to the user' do
      expect { post :create, params: { question: attributes_for(:question)} }.to change(user.questions, :count).by(1)
    end

    context 'with invalid attributes' do
      it 'does not save the question' do
        expect { post :create, params: { question: attributes_for(:question, :invalid) }, format: :js}.to_not change(Question, :count)
      end

      it 'renders new' do
        post :create, params: { question: attributes_for(:question, :invalid) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    context 'user is the author of question' do
      before { log_in(question.user) }

      context 'with valid attributes' do
        it 'assigns requested question to @question' do
          patch :update, params: { id: question, question: attributes_for(:question) }
          expect(assigns(:question)).to eq question
        end

        it 'changes question attributes' do
          patch :update, params: { id: question, question: { title: "New Title", body: "New Body" }}
          question.reload

          expect(question.title).to eq "New Title"
          expect(question.body).to eq "New Body"
        end

        it 'redirects to updated question' do
          patch :update, params: { id: question, question: { title: "New Title", body: "New Body" }}
          expect(response).to redirect_to question
        end
      end

      context 'with invalid attributes' do
        before { patch :update, params: { id: question, question: attributes_for(:question, :invalid) } }

        it 'does not change the question' do
          question.reload

          expect(question.title).to eq "MyString"
          expect(question.body).to eq "MyText"
        end

        it 'renders edit' do
          expect(response).to render_template :edit
        end
      end
    end

    context 'user is not the author of the question' do
      let!(:new_user) { create(:user) }
      before { log_in(new_user) } 

      it 'does not change answers attributes' do
        patch :update, params: { id: question, question: { body: "New Body" }}
        question.reload

        expect(question.body).not_to eq "New Body"
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:question) { create(:question) }

    context 'user is the author of question' do
      before { log_in(question.user) }    

      it 'deletes the question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1) 
      end

      it 'redirects to index' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    context 'user is not the author of question' do
      let!(:new_user) { create(:user) }
      before { log_in(new_user) }

      it 'does not delete the question' do
        expect { delete :destroy, params: { id: question } }.not_to change(Question, :count)    
        expect(response).to redirect_to question
      end
    end
  end
end

require 'rails_helper'
require 'json'

describe 'Answers API', type: :request do
  let(:headers) { { "CONTENT-TYPE" => "application/json", "ACCEPT" => "application/json"} }

  describe 'GET /api/v1/questions/1/answers/1' do
    let(:api_path) { '/api/v1/questions/1/answers/1' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:question) { create(:question) }
      let(:question_id) { question.id }
      let!(:answer) { create(:answer, question: question) }
      let(:answer_id) { answer.id }
      let(:answer_response) { json['answer'] }
      let!(:comments) { create_list(:comment, 2, commentable: answer, user: answer.user) }
      let(:comment) { comments.first }

      before { get "/api/v1/questions/#{question_id}/answers/#{answer_id}", params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields for answer' do
        %w[id body user_id created_at updated_at].each do |attr|
          expect(json['answer'][attr]).to eq answer.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(answer_response['user']['id']).to eq answer.user.id
      end
    end
  end

  describe 'GET /index' do
    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:question) { create(:question) }
      let!(:answers) { create_list(:answer, 2, question: question) }
      let!(:answer) { answers.first }

      before { get "/api/v1/questions/#{question.id}/answers", params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status code' do
        expect(response).to be_successful
      end

      it 'contains answers' do
        expect(json['answers'].size).to eq 2
      end

      %w[id body created_at updated_at].each do |attr|
        it "contains #{attr}" do
          expect(json['answers'].first[attr]).to eq answers.last.send(attr).as_json
        end
      end
    end
  end

  describe 'POST /create' do
    let(:question) { create(:question) }
    let(:id) { question.id }

    context 'authorized' do
      let(:access_token) { create(:access_token) }

      it 'returns 200 status code' do
        post_answer_create_request
        expect(response).to be_success
      end

      it 'creates an answer' do
        expect { post_answer_create_request }.to change(Answer, :count).by(1)
      end

      it 'returns the answer' do
        post_answer_create_request
        expect(response.body).to have_json_size(1)
      end

      %w(id body created_at updated_at question_id user_id).each do |attr|
        it "contains #{attr}" do
          post_answer_create_request
          expect(response.body).to be_json_eql(assigns(:answer).send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end
    end
  end

  private

    def post_answer_create_request
      post "/api/v1/questions/#{id}/answers", params: { answer: attributes_for(:answer), question: question, 
                                                        format: :json, access_token: access_token.token }
    end
end


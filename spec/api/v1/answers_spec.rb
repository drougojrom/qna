require 'rails_helper'

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

      before { get "/api/v1/questions/#{question_id}/answers/#{answer_id}", params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns all public fields for answer' do
        %w[id body created_at updated_at].each do |attr|
          expect(json['answer'][attr]).to eq answer.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(answer_response['user']['id']).to eq answer.user.id
      end
    end
  end
end


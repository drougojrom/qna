require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "CONTENT-TYPE" => "application/json", "ACCEPT" => "application/json"} }

  describe 'GET /api/v1/questions' do
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

      before { get "/api/v1/questions/#{question_id}/answers/#{answer_id}", params: { format: :json, access_token: access_token.token } }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns a list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields for question' do
        %w[id body created_at updated_at].each do |attr|
          expect(json['answers'].first[attr]).to eq answer.first.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_response['user']['id']).to eq question.user.id
      end

      it 'contains short title' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do
        let(:answer) { answers.last }
        let(:answer_response) { question_response['answers'].first }

        it 'returns a list of questions' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields for question' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end
end


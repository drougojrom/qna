require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "CONTENT-TYPE" => "application/json", "ACCEPT" => "application/json"} }

  describe 'GET /api/v1/questions' do
    context 'unauthorized user' do
      it 'returns 401 status if no access token' do
        get '/api/v1/questions/', headers: headers
        expect(response.status).to eq 401
      end

      it 'returns 401 status if token invalid' do
        get '/api/v1/questions',
            params: { access_token: '123123' },
            headers: headers
        expect(response.status).to eq 401
      end

      context 'authorized' do
        let(:access_token) { create(:access_token) }
        let!(:questions) { create_list(:question, 2) }
        let(:question) { questions.first }
        let(:question_response) { json.first }
        let!(:answers) { create_list(:answer, 3, question: question) }

        before do
          get '/api/v1/questions',
              params: { access_token: access_token.token },
              headers: headers
        end

        it 'returns 200 status' do
          expect(response).to be_successful
        end

        it 'returns a list of questions' do
          expect(json.size).to eq 2
        end

        it 'returns all public fields for question' do
          %w[id title body user_id created_at updated_at].each do |attr|
            expect(json.first[attr]).to eq questions.first.send(attr).as_json
          end
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
end

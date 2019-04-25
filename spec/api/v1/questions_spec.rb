require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "CONTENT-TYPE" => "application/json", "ACCEPT" => "application/json"} }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }

    it_behaves_like 'API Authorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question, user: question.user) }

      before do
        get api_path, params: { access_token: access_token.token }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns a list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields for question' do
        %w[id title body created_at updated_at].each do |attr|
          expect(json['questions'].first[attr]).to eq questions.first.send(attr).as_json
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

        it 'returns a list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it 'returns all public fields for answers' do
          %w[id body created_at updated_at].each do |attr|
            expect(answer_response[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'POST /create' do
    context 'authorized' do
      let(:access_token) { create(:access_token) }

      it 'returns 200 status code' do
        post_question_create_request
        expect(response).to be_success
      end

      it 'creates a question' do
        expect { post_question_create_request }.to change(Question, :count).by(1)
      end

      it 'returns the question' do
        post_question_create_request
        expect(response.body).to have_json_size(1)
      end

      %w(id title body created_at updated_at).each do |attr|
        it "contains #{attr}" do
          post_question_create_request
          expect(response.body).to be_json_eql(assigns(:question).send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end
    end
  end

  private

  def post_question_create_request
    post '/api/v1/questions', params: { question: attributes_for(:question), format: :json, 
                                        access_token: access_token.token }
  end
end

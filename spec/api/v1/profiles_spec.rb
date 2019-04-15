require 'rails_helper'

describe 'Profiles API', type: :request do

  let(:headers) { { "CONTENT-TYPE" => "application/json",
                    "ACCEPT" => "application/json"} }

  describe 'GET /api/v1/profiles/me' do
    context 'unauthorized user' do
      it 'returns 401 status if no access toke' do
        get '/api/v1/profiles/me', headers: headers
        expect(response.status).to eq 401
      end

      it 'returns 401 status if token invalid' do
        get '/api/v1/profiles/me', params: { access_token: '123123' }, headers: headers
        expect(response.status).to eq 401
      end
    end

    context 'authorized' do
      let(:access_token) { create :access_token }
      it 'returns 200 status' do
        get '/api/v1/profiles/me', params: { access_token: access_token.token }, headers: headers
        expect(response).to be_successful
      end
    end
  end
end

shared_examples_for 'API Authorizable' do
  context 'unauthorized user' do
    it 'returns 401 status if no access token' do
      do_request(method, api_path, headers: headers)
      expect(response.status).to eq 401
    end

    it 'returns 401 status if token invalid' do
      do_request(method, api_path, params: { access_token: '123123' }, headers: headers)
      expect(response.status).to eq 401
    end
  end
end
require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    request.env['omniauth.auth'] = oauth_data
  end

  describe '#GET Github' do
    let(:oauth_data) { OmniAuth::AuthHash.new( provider: 'github', uid: '123',
                                              info: { email: 'test@33user.com' } ) }

    it 'finds user from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :github
    end

    context 'user exists' do
      let(:user) { create :user }

      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :github
      end

      it 'login user' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user does not exist' do
      before do
        allow(User).to receive(:find_for_oauth)
        get :github
      end

      it 'redirects to root path if user does not exist' do
        expect(response).to redirect_to root_path
      end

      it 'does not log in user' do
        expect(subject.current_user).to_not be
      end
    end
  end

  describe '#GET twitter' do
    let(:oauth_data) { OmniAuth::AuthHash.new( provider: 'twitter', uid: '123',
                                              info: { email: 'test@33user.com' } ) }
    it 'finds user from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:find_for_oauth).with(oauth_data)
      get :twitter
    end

    context 'user exists' do
      let(:user) { create :user }

      before do
        allow(User).to receive(:find_for_oauth).and_return(user)
        get :twitter
      end

      it 'login user' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user does not exist' do
      before do
        allow(User).to receive(:find_for_oauth)
        get :twitter
      end

      it 'redirects to root path if user does not exist' do
        expect(response).to redirect_to root_path
      end

      it 'does not log in user' do
        expect(subject.current_user).to_not be
      end
    end
  end
end

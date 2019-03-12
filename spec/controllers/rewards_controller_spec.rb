require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  describe 'GET #index' do
    let!(:rewards) { create_list :reward, 3 }
    before { log_in rewards.first.user }  
    before { get :index, params: {user_id: rewards.first.user} }

    it 'renders index view' do
      expect(response).to render_template :index
    end

    it 'populates created rewards' do
      expect(assigns(:rewards)).to match(controller.current_user.rewards)
    end
  end
end

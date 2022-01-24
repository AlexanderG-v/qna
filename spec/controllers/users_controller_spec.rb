require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let!(:user) { create(:user) }
  let!(:user_2) { create(:user) }
  let(:question) { create :question, author: user }
  let(:rewards) { create_list(:reward, 3, question: question) }

  describe 'GET #show_rewards' do
    context 'Authenticated user' do
      before do
        login(user)

        get :show_rewards, params: { id: user }
      end

      it 'assigns the requested reward to @rewards' do
        expect(assigns(:rewards)).to match_array(user.rewards)
      end

      it 'render template show rewards' do
        expect(response).to render_template :show_rewards
      end
    end

    it 'Authenticated user without rewards' do
      login(user_2)

      get :show_rewards, params: { id: user_2 }
      expect(assigns(:rewards)).to_not match_array(rewards)
    end

    context 'Not authenticated user' do
      it 'can not see rewards' do
        get :show_rewards, params: { id: user }
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end

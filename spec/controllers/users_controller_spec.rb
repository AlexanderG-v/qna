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

  describe 'Get #email' do
    before { get :email }

    it 'assigns the requested user to @user' do
      expect(assigns(:user)).to be_a_new(User)
    end

    it 'renders email view' do
      expect(response).to render_template :email
    end
  end

  describe 'Post #set_email' do
    let!(:oauth_data) { { 'provider' => 'provider', 'uid' => 123 } }

    before { session[:oauth_data] = oauth_data }

    it 'create a new user' do
      expect { post :set_email, params: { user: attributes_for(:user) } }.to change(User, :count).by(1)
    end

    it 'create a new authorization' do
      expect do
        post :set_email, params: { user: attributes_for(:user),
                                   provider: session[:oauth_data]['provider'],
                                   uid: session[:oauth_data]['uid'] }
      end.to change(Authorization, :count).by(1)
    end

    it 'redirects to root' do
      post :set_email, params: { user: attributes_for(:user) }
      expect(response).to redirect_to root_path
    end
  end
end

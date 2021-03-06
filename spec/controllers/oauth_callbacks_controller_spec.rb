require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end
  
  shared_examples 'Providers' do |provider|
    describe provider.to_s do
      let(:oauth_data) { { 'provider' => provider, 'uid' => 123 } }

      it 'finds user from oauth data' do
        allow(request.env).to receive(:[]).and_call_original
        allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
        expect(User).to receive(:find_for_oauth).with(oauth_data)
        get provider.to_sym
      end

      context 'user exists' do
        let!(:user) { create(:user) }

        before do
          allow(User).to receive(:find_for_oauth).and_return(user)
          get provider.to_sym
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
          get provider.to_sym
        end

        it 'redirects to root path' do
          expect(response).to redirect_to root_path
        end

        it 'does not login user' do
          expect(subject.current_user).to_not be
        end
      end
    end
  end

  describe 'Github' do
    it_behaves_like 'Providers', 'github'
  end

  describe 'VKontakte' do
    it_behaves_like 'Providers', 'vkontakte'
  end
end

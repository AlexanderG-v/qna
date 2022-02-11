require 'rails_helper'

feature 'User can register in the system', "
  To be able to ask questions and answers
" do
  given(:user) { create(:user) }

  background { visit new_user_registration_path }

  scenario 'Unregistered user tries to sign up' do
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_button 'Sign up'

    expect(page).to have_content 'You have signed up successfully'
  end

  scenario 'Registered user tries to sign up' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_button 'Sign up'

    expect(page).to have_content 'Email has already been taken'
  end

  describe 'Can sign in user with account' do
    describe 'Github' do
      it 'user sign in with correct data' do
        visit new_user_registration_path
        expect(page).to have_content 'Sign in with GitHub'

        mock_auth_hash('github', email: 'user@test.com')
        click_link 'Sign in with GitHub'

        within '.navbar' do
          expect(page).to have_content 'user@test.com'
        end
        expect(page).to have_content 'Ask question'
        expect(page).to have_content 'Successfully authenticated from Github account.'
      end

      it 'can handle authentication error' do
        invalid_mock 'github'
        visit new_user_registration_path
        expect(page).to have_content 'Sign in with GitHub'

        click_link 'Sign in with GitHub'

        expect(page).to have_content 'Could not authenticate you from GitHub because "Invalid credentials"'
      end
    end
  end
end

require 'rails_helper'

feature 'User can log out of system', "
  to end the session
" do
  given(:user) { create(:user) }

  scenario 'Authenticated user can log out of the system' do
    sign_in(user)

    click_on 'Log out'

    expect(page).to have_content 'Signed out successfully'
  end
end

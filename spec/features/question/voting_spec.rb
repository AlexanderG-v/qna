require 'rails_helper'

feature 'User can change question rating by voting', "
  In order to vote up or down a question
  As un authenticated user
  I'd like to be able vote up or down a question
" do
  given(:user) { create(:user) }
  given(:not_author) { create(:user) }
  given!(:question) { create(:question, author: user) }

  describe 'Unauthenticated user' do
    scenario "can't to change question rating by voting" do
      visit question_path(question)

      expect(page).to_not have_link 'Cancel vote'
      expect(page).to_not have_link 'UP'
      expect(page).to_not have_link 'DOWN'
    end
  end

  describe 'Authenticated author' do
    scenario 'tries to change question rating by voting' do
      sign_in(user)
      visit question_path(question)

      expect(page).to_not have_link 'Cancel vote'
      expect(page).to_not have_link 'UP'
      expect(page).to_not have_link 'DOWN'
    end
  end

  describe 'Authenticated user', js: true do
    before do
      sign_in(not_author)
      visit question_path(question)
    end

    scenario 'vote up a question' do
      within '.questions .rating' do
        click_on 'UP'

        expect(page).to have_content '1'
        expect(page).to have_link 'Cancel vote'
        expect(page).to_not have_link 'UP'
        expect(page).to_not have_link 'DOWN'
      end
    end

    scenario 'vote down a question' do
      within '.questions .rating' do
        click_on 'DOWN'

        expect(page).to have_content '-1'
        expect(page).to have_link 'Cancel vote'
        expect(page).to_not have_link 'UP'
        expect(page).to_not have_link 'DOWN'
      end
    end

    scenario 'vote cancel a question' do
      within '.questions .rating' do
        click_on 'UP'

        expect(page).to_not have_link 'UP'
        expect(page).to_not have_link 'DOWN'

        click_on 'Cancel vote'

        expect(page).to have_content '0'
        expect(page).to_not have_link 'Cancel vote'
        expect(page).to have_link 'UP'
        expect(page).to have_link 'DOWN'
      end
    end
  end
end

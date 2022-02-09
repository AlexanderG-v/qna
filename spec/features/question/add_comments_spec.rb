require 'rails_helper'

feature 'User can comment on the question', "
 In order to comment a question
 As authenticated user
 I'd like to be able to write comments on a question
" do
  given(:user) { create(:user) }
  given(:question) { create :question, author: user }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'creates a comment to question' do
      click_link 'Add comment'
      fill_in 'comment[body]', with: 'text text text'
      click_button 'Comment'

      expect(page).to have_current_path question_path(question), ignore_query: true
      within '.question' do
        expect(page).to have_content 'text text text'
      end
    end

    scenario 'creates a comment to question with error' do
      click_link 'Add comment'
      fill_in 'comment[body]', with: ''
      click_button 'Comment'

      within '.question' do
        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  scenario 'Unauthenticated user tries trying to create a comment to question' do
    visit question_path(question)

    within '.question' do
      expect(page).to_not have_link 'Add comment'
    end
  end

  context 'multiple sessions', js: true do
    scenario "comment to the question appears on another user's page" do
      Capybara.using_session('user') do
        sign_in(user)

        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within '.question' do
          click_link 'Add comment'
          fill_in 'comment[body]', with: 'text text text'
          click_button 'Comment'

          expect(page).to have_content 'Comment text'
          expect(page).to_not have_selector 'textarea'
        end
      end

      Capybara.using_session('guest') do
        within '.question' do
          expect(page).to have_content 'Comment text'
          expect(page).to_not have_selector 'textarea'
        end
      end
    end
  end
end

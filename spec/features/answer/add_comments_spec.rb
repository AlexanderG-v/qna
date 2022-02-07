require 'rails_helper'

feature 'User can comment on the answer', "
 In order to comment an answer
 As authenticated user
 I'd like to be able to write comments on an answer
" do
  given(:user) { create(:user) }
  given(:question) { create :question, author: user }
  given!(:answer) { create :answer, question: question, author: user }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'creates a comment to answer' do
      within '.answers' do
        click_link 'Add comment'
        fill_in 'comment[body]', with: 'text text text'
        click_button 'Comment'

        expect(page).to have_current_path question_path(question), ignore_query: true
        expect(page).to have_content 'text text text'
      end
    end

    scenario 'creates a comment to answer with error' do
      within '.answers' do
        click_link 'Add comment'
        fill_in 'comment[body]', with: ''
        click_button 'Comment'

        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  scenario 'Unauthenticated user tries trying to create a comment to answer' do
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Add comment'
    end
  end
end

require 'rails_helper'

feature 'User being on question page can write an answer to question', "
  New form for answer should be on the 
  question page without going to another page
" do
  given(:user) { create(:user) }
  given(:question) { create :question, author: user }

  describe 'Authenticated user', js: true do
    
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'creates an answer to the question' do
      fill_in 'answer[body]', with: 'text text text'
      click_on 'Answer'

      expect(page).to have_current_path question_path(question), ignore_query: true
      within '.answers' do
        expect(page).to have_content 'text text text'
      end
    end

    scenario 'creates an answer to the question with error' do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Unauthenticated user tries trying to create an answer to question' do
    visit question_path(question)

    expect(page).to_not have_button 'Answer'
  end
end

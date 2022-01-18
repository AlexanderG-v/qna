require 'rails_helper'

feature 'Authenticated user can edit his question', "
  In order to correct the question
  As an author of question
  I'd like to be able to edit my question
" do
  given!(:user) { create :user }
  given!(:not_author) { create(:user) }
  given!(:question) { create :question, author: user }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'edit his question' do
      click_on 'Edit Question'

      within '.questions' do
        fill_in 'question[title]', with: 'edited title'
        fill_in 'question[body]', with: 'edited body'
        click_on 'Save'

        expect(page).to_not have_content question.title
        expect(page).to_not have_content question.body
        expect(page).to have_content 'edited title'
        expect(page).to have_content 'edited body'
        expect(page).to_not have_selector 'textfield'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edit his question with errors' do
      click_on 'Edit Question'

      within '.questions' do
        fill_in 'question[title]', with: ''
        fill_in 'question[body]', with: ''
        click_on 'Save'

        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  scenario "Authenticated user tries to edit other's question" do
    sign_in(not_author)
    visit question_path(question)

    expect(page).to_not have_link 'Edit Question'
  end
  
  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit Question'
  end
end

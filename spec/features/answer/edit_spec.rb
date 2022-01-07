require 'rails_helper'

feature 'Authenticated user can edit his answer', "
  In order to correct the answer
  As an author of answer
  I'd like to be able to edit my answer
" do
  given!(:user) { create :user }
  given!(:question) { create :question, author: user }
  given!(:answer) { create :answer, question: question, author: user }

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end


  describe 'Authenticated user', js: true do
    background do
      sign_in(user)

      visit question_path(question)
    end

    scenario 'edit his answer' do
      click_on 'Edit'

      within '.answers' do
        fill_in 'answer[body]', with: 'editer answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edit his answer with errors'
    scenario "tries to edit other's answer"
  end
end

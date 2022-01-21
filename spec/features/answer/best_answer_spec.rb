require 'rails_helper'

feature 'User can choose the best answer to the question', '
  To choose the best answer to a question over other answers
  As the author of the question
  I would like to choose the best answer to a question
' do
  given(:user) { create(:user) }
  given(:not_author) { create(:user) }
  given(:question) { create :question, author: user }
  given!(:answer) { create :answer, question: question, author: not_author }

  describe 'Authenticated user', js: true do
    scenario 'author of question can choose the best answer' do
      sign_in(user)

      visit question_path(question)

      within '.answers' do
        expect(page).to have_link 'Best answer'
        click_on 'Best answer'
        expect(page).to have_content 'The best answer'
      end
    end

    scenario 'not author of question, cannot choose the best answer' do
      sign_in(not_author)
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_link 'Best answer'
      end
    end
  end

  scenario 'Unauthenticated user can not choose the best answer to a question' do
    visit question_path(question)

    expect(page).to_not have_link 'Best answer'
  end
end

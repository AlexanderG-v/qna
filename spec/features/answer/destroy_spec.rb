require 'rails_helper'

feature 'Author can delete his answer', "
  in order to be able to delete your answer
  As an autor
  I would like to be able to delete this answer
" do
  given(:author) { create(:user) }
  given(:not_author) { create(:user) }
  given(:question) { create :question, author: author }
  given(:answer) { create :answer, question: question, author: author }
  given(:answer_with_links) { create(:answer, :with_links, question: question, author: author) }

  describe 'Author' do
    background do
      sign_in(author)
    end

    scenario 'can delete his answer', js: true do
      visit question_path(answer.question)

      click_on 'Delete answer'

      expect(page).to have_content 'Answer was successfully deleted'
    end

    scenario 'can delete links to answer', js: true do
      visit question_path(answer_with_links.question)

      within '.answers' do
        expect(page).to have_link 'MyString', href: 'https://github.com'
        click_on 'Delete link'

        expect(page).to_not have_link 'MyString'
        expect(page).to_not have_link 'Delit link'
      end
      expect(page).to have_content 'Link was successfully deleted'
    end
  end

  describe 'Not author' do
    background do
      sign_in(not_author)
    end

    scenario 'can not delete others answer' do
      visit question_path(question)

      expect(page).to_not have_link 'Delete answer'
    end

    scenario 'can not delete links to answer' do
      visit question_path(answer_with_links.question)

      within '.answers' do
        expect(page).to_not have_link 'Delit link'
      end
    end
  end
end

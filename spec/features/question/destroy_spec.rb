require 'rails_helper'

feature 'Author can delete his question', "
  in order to be able to delete your question
  As an autor
  I would like to be able to delete this question
" do
  given(:author) { create(:user) }
  given(:not_author) { create(:user) }
  given(:question) { create :question, author: author }
  given(:question_with_links) { create(:question, :with_links, author: author) }

  describe 'Author', js: true do
    before do
      sign_in(author)
    end

    scenario 'can delete his question' do
      visit question_path(question)

      click_on 'Delete Question'

      expect(page).to have_content 'Question was successfully deleted'
    end

    scenario 'can delete links to question' do
      visit question_path(question_with_links)

      within '.questions' do
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

    scenario 'can not delete others question' do
      visit question_path(question)

      expect(page).to_not have_link 'Delete Question'
    end

    scenario 'Not Author can not delete files attached to question' do
      visit question_path(question_with_links)

      within '.questions' do
        expect(page).to_not have_link 'Delit link'
      end
    end
  end
end

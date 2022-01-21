require 'rails_helper'

feature 'Authenticated user can edit his question', "
  In order to correct the question
  As an author of question
  I'd like to be able to edit my question
" do
  given(:user) { create :user }
  given(:not_author) { create(:user) }
  given(:question) { create :question, author: user }
  given(:question_with_files) { create(:question, :with_files, author: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)

      click_on 'Edit Question'
    end

    scenario 'edit his question' do
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
      within '.questions' do
        fill_in 'question[title]', with: ''
        fill_in 'question[body]', with: ''
        click_on 'Save'

        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario 'edit his question with attached files' do
      within '.questions' do
        attach_file 'question[files][]', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
      
    scenario 'Author can delete files attached to question' do
      visit question_path(question_with_files)
      
      within '.questions' do
        click_on 'Delete file'
      
        expect(page).to_not have_link 'rails_helper.rb'
      end
      expect(page).to have_content 'File was successfully deleted'
    end
  end

  scenario 'Not Author can not delete files attached to question' do
    sign_in(not_author)
    visit question_path(question_with_files)

    within '.questions' do
      expect(page).to_not have_link 'Delete file'
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

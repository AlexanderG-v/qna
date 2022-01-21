require 'rails_helper'

feature 'Authenticated user can edit his answer', "
  In order to correct the answer
  As an author of answer
  I'd like to be able to edit my answer
" do
  given(:user) { create :user }
  given(:not_author) { create(:user) }
  given(:question) { create(:question, author: user) }
  given!(:answer) { create(:answer, question: question, author: user) }
  given(:answer_with_files) { create(:answer, :with_files, question: question, author: user) }

  scenario 'Unauthenticated user can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)

      click_on 'Edit'
    end

    scenario 'edit his answer' do
      within '.answers' do
        fill_in 'answer[body]', with: 'edited answer'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edit his answer with errors' do
      within '.answers' do
        fill_in 'answer[body]', with: ''
        click_on 'Save'

        expect(page).to have_content "Body can't be blank"
      end
    end

    scenario 'edit his answer with attached files' do
      within '.answers' do
        fill_in 'answer[body]', with: 'edited answer'

        attach_file 'answer[files][]', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'Author can delete files attached to answer' do
      visit question_path(answer_with_files.question)
      
      within '.answers' do
        click_on 'Delete file'
      
        expect(page).to_not have_link 'rails_helper.rb'
      end
      expect(page).to have_content 'File was successfully deleted'
    end
  end

  scenario 'Not Author can not delete files attached to answer' do
    sign_in(not_author)
    visit question_path(answer_with_files.question)

    within '.answers' do
      expect(page).to_not have_link 'Delete file'
    end
  end

  scenario "Authenticated user tries to edit other's answer" do
    sign_in(not_author)
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
end

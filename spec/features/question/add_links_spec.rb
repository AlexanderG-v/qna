require 'rails_helper'

feature 'User can add links to question', "
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
" do
  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/AlexanderG-v/ebdb690c69f3bb79b4cf92a502bca73b' }
  given(:other_url) { 'https://github.com/AlexanderG-v' }
  given(:invalid_url) { 'Invalid_url' }

  describe 'User adds link when asks question', js: true do
    background do
      sign_in(user)
      visit new_question_path

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
    end

    scenario 'with valid url' do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Add link'

      within '.nested-fields' do
        fill_in 'Link name', with: 'GitHub'
        fill_in 'Url', with: other_url
      end

      click_on 'Ask'
    
      within '.questions' do
        expect(page).to have_link 'My gist', href: gist_url
        expect(page).to have_link 'GitHub', href: other_url
      end
    end

    scenario 'with invalid url' do
      fill_in 'Link name', with: 'Invalid'
      fill_in 'Url', with: invalid_url

      click_on 'Ask'

      expect(page).to_not have_link 'Invalid'
      expect(page).to have_content 'Links url is invalid'
    end

    scenario 'open gist url' do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Ask'

      within '.questions' do
        expect(page).to have_link 'My gist', href: gist_url
        expect(page).to have_content 'Test gist'
      end
    end
  end
end

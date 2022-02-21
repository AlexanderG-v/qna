require 'rails_helper'

feature 'User can add links to question', "
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
" do
  it_behaves_like 'add_links' do
    given(:button) { 'Ask' }
    given(:resource_class) { '.questions' }
    given(:initial_data) do
      sign_in(user)
      visit new_question_path

      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
    end
  end
end

require 'rails_helper'

feature 'User can add links to answer', "
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
" do
  it_behaves_like 'add_comments' do
    given(:question) { create :question, author: user }
    given(:button) { 'Answer' }
    given(:resource_class) { '.answers' }
    given(:initial_data) do
      sign_in(user)
      visit question_path(question)

      fill_in 'answer[body]', with: 'text text text'
    end
  end
end

require 'rails_helper'

feature 'Author can delete his question', "
  in order to be able to delete your question
  As an autor
  I would like to be able to delete this question
" do
given(:author) { create(:user) }
given(:not_author) { create(:user) }
given(:question) { create :question, author: author }

  scenario 'Author can delete his question' do
    sign_in(author)
    visit question_path(question)

    click_on 'Delete'

    expect(page).to have_content 'Question was successfully deleted'
  end

  scenario 'Not Author can not delete others question' do
    sign_in(not_author)
    visit question_path(question)

    click_on 'Delete'

    expect(page).to have_content 'You are not the author of the question.'
  end
end

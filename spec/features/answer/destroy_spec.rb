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

  scenario 'Author can delete his answer' do
    sign_in(author)
    visit question_path(answer.question)

    click_on 'Delete Answer'

    expect(page).to have_content 'Answer was successfully deleted'
  end

  scenario 'Not Author can not delete others answer' do
    sign_in(not_author)
    visit question_path(question)

    expect(page).to_not have_link 'Delete Answer'
  end
end

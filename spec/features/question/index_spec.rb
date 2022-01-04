require 'rails_helper'

feature 'User can view list of questions', "
  To find the question he is interested in
" do
  given(:user) { create :user }
  given!(:question) { create_list :question, 3, author: user }

  scenario 'User can view question list' do
    visit questions_path
    expect(page).to have_content 'All Questions'
    expect(page).to have_content 'Title'
    expect(question.size).to eq Question.count
    question.each { |question| expect(page).to have_content question.title }
  end
end

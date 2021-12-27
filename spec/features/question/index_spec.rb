require 'rails_helper'

feature 'User can view list of questions', "
  To find the question he is interested in
" do
  given!(:question) { create_list(:question, 3) }

  scenario 'User can view question list' do
    visit questions_path
    expect(page).to have_content 'All Questions'
    expect(page).to have_content 'Title'
    expect(page.all('tr td').count).to eq 3
  end
end

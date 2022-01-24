require 'rails_helper'

feature 'User can add reward to question', "
In order to give out an award for the best answer to a question
As the author of the question
I would like to be able to add a reward
" do
  given(:user) { create(:user) }

  scenario 'User adds reward when asks question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
    fill_in 'Reward name', with: 'New reward'

    attach_file 'Image', "#{Rails.root}/app/assets/images/badge.png"

    click_on 'Ask'

    expect(Question.last.reward).to eq Reward.last
  end

  scenario 'User assigns reward with errors when asks question' do
    sign_in(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
    fill_in 'Reward name', with: ''

    attach_file 'Image', "#{Rails.root}/spec/rails_helper.rb"

    click_on 'Ask'

    expect(page).to have_content "Reward name can't be blank"
  end
end

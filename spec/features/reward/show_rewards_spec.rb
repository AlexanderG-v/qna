require 'rails_helper'

feature 'User can view his rewards', '
  To see the number of rewards
  as a user
  I would like to be able to view a list of my awards
' do
  given(:user) { create(:user) }
  given!(:question) { create(:question, author: user) }
  given(:answer) { create(:answer) }
  given!(:reward) { create(:reward, user: user, question: question) }

  scenario 'Authenticated user check his badges' do
    sign_in(user)
    
    visit root_path

    within '.navbar' do
      page.has_css? 'bi.bi-trophy'
      click_on 'Rewards'

      # find('bi.bi-trophy').click
    end
    expect(page).to have_content(reward.name)
    expect(page).to have_content(reward.question.title)
    expect(page).to have_xpath("//img")
  end

  scenario 'Unauthenticated user tries to see a rewards' do
    visit root_path
    
    within '.navbar' do
      expect(page).to_not have_link 'Rewards'
      expect(page).to_not have_css '.bi.bi-trophy'
    end
  end
end

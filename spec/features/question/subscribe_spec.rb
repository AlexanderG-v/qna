require 'rails_helper'

feature 'User can subscribe to updates on the question', "
  In order to subscribe the question
  As an authenticated user
  I'd like to be able to subscribe to the question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, author: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'User subscribes to updates on the question' do
      click_on 'Subscribe'

      expect(page).to have_link 'Unsubscribe'
      expect(page).to_not have_link 'Subscribe'
    end

    context 'When user already subscribe' do
      given!(:subscription) { question.subscriptions.create(user: user) }

      scenario 'User unsubscribes to updates on the question' do
        visit question_path(question)

        click_on 'Unsubscribe'

        expect(page).to have_link 'Subscribe'
        expect(page).to_not have_link 'Unsubscribe'
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'User assigns reward when asks question' do
      visit question_path(question)

      expect(page).to_not have_link 'Subscribe'
      expect(page).to_not have_link 'Unsubscribe'
    end
  end
end

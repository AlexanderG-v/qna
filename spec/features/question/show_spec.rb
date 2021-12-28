require 'rails_helper'

feature 'User can view the question and the answers to it', "
  I'd like to be able to views current 
  question and the answers to it
" do
    given(:user) { create(:user) }
    given(:question) { create(:question) }
    given!(:answers) { create_list(:answer, 3, question: question) }

    scenario 'Authenticated user can view question and answers to it' do
      sign_in(user)
      visit question_path(question) 
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    
      answers.each do |answer| 
        expect(page).to have_content answer.body 
      end
    end
  
    scenario 'Unauthenticated user can view question and answers to it' do
      visit question_path(question) 
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    
      answers.each do |answer| 
        expect(page).to have_content answer.body 
      end
    end
end

require 'rails_helper'

feature 'User can change answer rating by voting', "
  In order to vote up or down a answer
  As un authenticated user
  I'd like to be able vote up or down a answer
" do
  it_behaves_like 'voting' do
    given(:user) { create(:user) }
    given(:not_author) { create(:user) }
    given!(:question) { create(:question, author: user) }
    given!(:answer) { create(:answer, question: question, author: user) }
    given(:resource_class) { ".answer-id-#{answer.id} .rating" }
  end
end

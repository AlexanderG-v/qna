require 'rails_helper'

feature 'User can comment on the question', "
 In order to comment a question
 As authenticated user
 I'd like to be able to write comments on a question
" do
  it_behaves_like 'add_comments' do
    given(:user) { create(:user) }
    given(:question) { create :question, author: user }
    given(:resource_class) { '.question' }
    given(:resource_comment) { question }
  end
end

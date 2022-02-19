require 'rails_helper'

feature 'User can comment on the answer', "
 In order to comment an answer
 As authenticated user
 I'd like to be able to write comments on an answer
" do
  it_behaves_like 'add_comments' do
    given(:user) { create(:user) }
    given!(:question) { create :question, author: user }
    given!(:answer) { create :answer, question: question, author: user }
    given(:resource_class) { '.answers' }
    given(:resource_comment) { answer.question }
  end
end

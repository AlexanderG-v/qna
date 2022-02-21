require 'rails_helper'

feature 'User can change question rating by voting', "
  In order to vote up or down a question
  As un authenticated user
  I'd like to be able vote up or down a question
" do
  it_behaves_like 'voting' do
    given(:user) { create(:user) }
    given(:not_author) { create(:user) }
    given!(:question) { create(:question, author: user) }
    given(:resource_class) { '.questions .rating' }
  end
end

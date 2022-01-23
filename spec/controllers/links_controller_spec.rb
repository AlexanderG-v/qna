require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, :with_links, author: user) }

  describe 'DELETE #destroy' do
    context 'Author quwestion' do
      before { login(user) }

      it 'delete the attached file' do
        expect { delete :destroy, params: { id: question.links.first }, format: :js }.to change(question.links, :count).by(-1)
      end

      it 'render destroy view' do
        delete :destroy, params: { id: question.links.first }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Not author' do
      let(:not_author) { create :user }

      it 'tries to delete file' do
        login(not_author)

        expect { delete :destroy, params: { id: question.links.first }, format: :js }.to_not change(question.links, :count)
      end
    end

    context 'Not registered user' do
      it 'tries to delete' do
        expect { delete :destroy, params: { id: question.links.first }, format: :js }.to_not change(question.links, :count)
      end
    end
  end
end

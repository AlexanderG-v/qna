require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, :with_links, author: user) }
  let(:answer) { create(:answer, :with_links, question: question, author: user) }

  describe 'DELETE #destroy' do
    context 'Author of question' do
      before { login(user) }

      it 'delete the link' do
        expect { delete :destroy, params: { id: question.links.first }, format: :js }.to change(question.links, :count).by(-1)
      end

      it 'render destroy view' do
        delete :destroy, params: { id: question.links.first }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Author of answer' do
      before { login(user) }

      it 'delete the link' do
        expect { delete :destroy, params: { id: answer.links.first }, format: :js }.to change(answer.links, :count).by(-1)
      end

      it 'render destroy view' do
        delete :destroy, params: { id: answer.links.first }, format: :js
        expect(response).to render_template :destroy
      end
    end

    context 'Not author' do
      let(:not_author) { create :user }

      it 'of question tries to delete link' do
        login(not_author)
        expect { delete :destroy, params: { id: question.links.first }, format: :js }.to_not change(question.links, :count)
      end

      it 'of answer tries to delete link' do
        login(not_author)
        expect { delete :destroy, params: { id: answer.links.first }, format: :js }.to_not change(answer.links, :count)
      end
    end

    context 'Not registered user' do
      it 'tries to delete question links' do
        expect { delete :destroy, params: { id: question.links.first }, format: :js }.to_not change(question.links, :count)
      end

      it 'tries to delete answer links' do
        expect { delete :destroy, params: { id: answer.links.first }, format: :js }.to_not change(answer.links, :count)
      end
    end
  end
end

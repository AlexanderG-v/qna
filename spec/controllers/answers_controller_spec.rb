require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create :user }
  let(:question) { create :question, author: user }

  describe 'POST #create' do
    before { login(user) }

    context 'whth valid attributes' do
      it 'save a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'renders create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer), format: :js }
        expect(response).to render_template :create
      end
    end

    context 'whth invalid attributes' do
      it 'doen not save the answer' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) }, format: :js }.to_not change(Answer, :count)
      end

      it 'renders create template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid), format: :js }
        expect(response).to render_template :create
      end
    end
  end

  describe 'PACH #update' do
    before { login(user) }

    let(:answer) { create :answer, question: question, author: user }

    context 'with valid attributes' do
      it 'changes answer attributes' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

      it 'renders update template' do
        patch :update, params: { id: answer, answer: { body: 'new body' } }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalid attributes' do
      it 'does not change answer attributes' do
        expect do
          patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        end.to_not change(answer, :body)
      end

      it 'renders update template' do
        patch :update, params: { id: answer, answer: attributes_for(:answer, :invalid) }, format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe 'DELETE #destroy' do
    before { login(user) }

    context 'user is author' do
      let!(:answer) { create :answer, question: question, author: user }

      it 'deletes the answer' do
        expect { delete :destroy, params: { id: answer }, format: :js }.to change(question.answers, :count).by(-1)
      end

      it 'renders destroy template' do
        delete :destroy, params: { id: answer, format: :js }
        expect(response).to render_template :destroy
      end
    end

    context 'user is not author' do
      let(:not_author) { create :user }
      let(:other_question) { create :question, author: not_author }
      let!(:other_answer) { create :answer, question: other_question, author: not_author }

      it 'does not delete the answer' do
        expect { delete :destroy, params: { id: other_answer }, format: :js }.to_not change(other_question.answers, :count)
      end

      it 'renders destroy template' do
        delete :destroy, params: { id: other_answer }, format: :js
        expect(response).to render_template :destroy
      end
    end
  end

  describe 'POST #best_answer' do
    let(:not_author_question) { create(:user) }
    let(:answer) { create(:answer, question: question, author: user) }
    let(:answer_2) { create(:answer, question: question, author: not_author_question) }

    context 'Author of question' do
      before { login(user) }

      it 'can choose the best answer' do
        post :best_answer, params: { id: answer, format: :js }
        question.reload
        expect(question.best_answer).to eq answer
      end

      it 'render template best answer' do
        post :best_answer, params: { id: answer, format: :js }
        expect(response).to render_template :best_answer
      end
    end

    context 'Not author of question' do
      before { login(not_author_question) }
      
      it 'can not choose the best answer' do
        post :best_answer, params: { id: answer, format: :js }
        question.reload
        expect(question.best_answer).to_not eq answer
      end
    end
  end
end

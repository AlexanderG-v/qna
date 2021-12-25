require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create_list(:answer, 3) }

  describe 'GET #show' do
    before { get :show, params: { id: answer, question_id: question } }

    it 'assigns the requested question to @question.answer' do
      expect(assigns(:answer)).to eq answer
    end

    it 'render show view' do
      expect(response).to render_template :show
    end
  end
end

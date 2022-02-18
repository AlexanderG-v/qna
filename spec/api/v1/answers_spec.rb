require 'rails_helper'

describe 'Answers API', type: :request do
  let(:headers) { { "ACCEPT" => "application/json" } }
  let(:user) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: user.id) }

  describe 'GET /api/v1/questions/:id/answers' do
    let(:user) { create :user }
    let(:method) { :get }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let!(:question) { create(:question, author: user) }

    it_behaves_like 'API Unauthorizable'

    context 'authorized' do
      let(:user) { create :user }
      let(:answer_response) { json['answers'].first }
      let!(:answers) { create_list(:answer, 4, question: question, author: user) }
      let(:answer) { answers.first }
      let(:resource) { answer }
      let(:resource_response) { answer_response }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API Authorizable'

      it_behaves_like 'API returns all public fields' do
        let(:public_fields) { %w[id body created_at updated_at] }
      end

      it_behaves_like 'API contains object' do
        let(:objects) { %w[author question] }
      end

      it_behaves_like 'API returns list of resource' do
        let(:resource_contents) { %w[id body] }
      end
    end
  end
end

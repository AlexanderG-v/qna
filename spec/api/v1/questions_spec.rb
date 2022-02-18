require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "ACCEPT" => "application/json" } }
  
  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    
    it_behaves_like 'API Unauthorizable' do
      let(:method) { :get }
    end

    context 'authorized' do
      let(:user) { create :user }
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2, author: user) }
      let(:question) { questions.first }
      let(:question_response) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, author: user, question: question) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API Authorizable'

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it_behaves_like 'API returns all public fields' do
        let(:resource) { questions.first }
        let(:resource_response) { json['questions'].first }
        let(:public_fields) { %w[id title body created_at updated_at] }
      end

      it_behaves_like 'API contains object' do
        let(:resource) { questions.first }
        let(:resource_response) { json['questions'].first }
        let(:objects) { %w[author] }
      end

      it 'contains short title and body' do
        expect(question_response['short_title']).to eq question.title.truncate(7)
      end

      describe 'answers' do      
        it 'returns list of answers' do
          expect(question_response['answers'].size).to eq 3
        end

        it_behaves_like 'API returns all public fields' do
          let(:resource) { answers.first }
          let(:resource_response) { question_response['answers'].first }
          let(:public_fields) { %w[id body author_id created_at updated_at] }
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    let(:user) { create :user }
    let(:access_token) { create(:access_token) }
    let!(:question) { create(:question, :with_reward, :with_files, :with_links, :with_comments, author: user) }
    let(:method) { :get }
    let(:api_path) { "/api/v1/questions/#{question.id}" }

    it_behaves_like 'API Unauthorizable'

    context 'authorized' do
      let(:resource) { question }
      let(:resource_response) { json['question'] }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it_behaves_like 'API Authorizable'

      it_behaves_like 'API returns all public fields' do
        let(:public_fields) { %w[id title body created_at updated_at] }
      end
      
      it_behaves_like 'API contains object' do
        let(:objects) { %w[author reward] }
      end

      it_behaves_like 'API returns list of resource' do
        let(:resource_contents) { %w[comments files links] }
      end

      context 'question links' do
        it_behaves_like 'API returns all public fields' do
          let(:resource) { question.links.first }
          let(:resource_response) { json['question']['links'].first }
          let(:public_fields) { %w[id name url created_at updated_at] }
        end
      end

      context 'question comments' do
        it_behaves_like 'API returns all public fields' do
          let(:resource) { question.comments.first }
          let(:resource_response) { json['question']['comments'].first }
          let(:public_fields) { %w[id body user_id created_at updated_at] }
        end
      end

      it 'contains files url' do
        expect(json['question']['files'].first['url']).to eq Rails.application.routes.url_helpers.rails_blob_path(
          question.files.first, only_path: true
        )
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:method) { :post }
    let(:user) { create :user }
    let(:access_token) { create(:access_token, resource_owner_id: user.id) }
    let(:api_path) { '/api/v1/questions' }
    
    it_behaves_like 'API Unauthorizable'

    context 'authorized' do
      context 'with valid attributes' do
        let(:question) { attributes_for(:question, author: user) }
        let(:question_response) { json['question'] }

        before do
          post api_path,
               params: { access_token: access_token.token, question: question },
               headers: headers
        end

        it 'creates a new Question' do
          expect do 
            post api_path, params: { access_token: access_token.token, question: question },
                           headers: headers
          end.to change(Question, :count).by(1)
        end

        it_behaves_like 'API Authorizable'
    
        it 'contains user object' do
          expect(question_response['author']['id']).to eq access_token.resource_owner_id
        end
  
        it 'creates a question with the correct attributes' do
          expect(Question.last).to have_attributes question
        end
      end
    
      context 'with invalid attributes' do
        let(:question) { attributes_for(:question, :invalid) }
    
        before do
          post api_path,
               params: { access_token: access_token.token, question: question },
               headers: headers
        end

        it "doesn't save question, renders errors" do
          expect do 
            post api_path, params: { access_token: access_token.token, question: question },
                           headers: headers
          end.to_not change(Question, :count)
        end

        it 'returns status 422' do
          expect(response.status).to eq 422
        end

        it 'returns error' do
          expect(json['errors']).to_not be_nil
        end
      end
    end
  end
end

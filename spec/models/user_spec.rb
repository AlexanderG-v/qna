require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create :user }
  let(:not_autor) { create :user }

  it { should have_many(:questions).class_name('Question') }
  it { should have_many(:answers).class_name('Answer') }
  it { should have_many(:rewards).dependent(:nullify) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:authorizations).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:service) { double('FindForOauthService') }
    
    it 'call FindForOauthService' do
      expect(FindForOauthService).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      described_class.find_for_oauth(auth)
    end
  end

  context 'User author' do
    let(:question) { create :question, author: user }

    it 'of question' do
      expect(user).to be_author(question)
    end

    it 'of answer' do
      answer = create :answer, question: question, author: user
      expect(user).to be_author(answer)
    end
  end

  context 'User do not author' do
    let(:question) { create :question, author: not_autor }

    it 'of question' do
      expect(user).to_not be_author(question)
    end

    it 'of answer' do
      answer = create :answer, question: question, author: not_autor
      expect(user).to_not be_author(answer)
    end
  end
end

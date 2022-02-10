require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create :user }
  let(:not_autor) { create :user }

  it { should have_many(:questions).class_name('Question') }
  it { should have_many(:answers).class_name('Answer') }
  it { should have_many(:rewards).dependent(:nullify) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    
    context 'user already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(described_class.find_for_oauth(auth)).to eq user
      end
    end

    context 'user has not authorization' do
      context 'user already exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: user.email }) }

        it 'does not create new user' do
          expect { described_class.find_for_oauth(auth) }.to_not change(described_class, :count)
        end

        it 'creates authorization for user' do
          expect { described_class.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authirization with provider and uid' do
          authorization = described_class.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns the user' do
          expect(described_class.find_for_oauth(auth)).to eq user
        end
      end

      context 'user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new@user.com' }) }

        it 'creates new user' do
          expect { described_class.find_for_oauth(auth) }.to change(described_class, :count).by(1)
        end

        it 'returns new user' do
          expect(described_class.find_for_oauth(auth)).to be_a(described_class)
        end

        it 'fills new email' do
          user = described_class.find_for_oauth(auth)
          expect(user.email).to eq auth.info[:email]
        end

        it 'creates authorization for user' do
          user = described_class.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'creates authorization with provider and uid' do
          authorization = described_class.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
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

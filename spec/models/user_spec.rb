require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create :user }

  it { should have_many(:questions).class_name('Question') }
  it { should have_many(:answers).class_name('Answer') }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  context 'User author' do
    let(:question) { create :question, author: user }

    it 'of question' do
      expect(user).to be_author(question)
    end
  end

  context 'User do not author' do
    let(:another_user) { create :user }
    let(:question) { create :question, author: another_user }

    it 'of question' do
      expect(user).to_not be_author(question)
    end
  end
end

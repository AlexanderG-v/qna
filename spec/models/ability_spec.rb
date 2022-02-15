require 'rails_helper'

RSpec.describe Ability do
  subject(:ability) { described_class.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, role: 'admin' }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other_user) { create :user }
    let(:question) { create :question, :with_files, :with_links, author: user }
    let(:other_question) { create :question, :with_links, author: other_user }
    let(:answer) { create :answer, :with_files, :with_links, question: question, author: user }
    let(:other_answer) { create :answer, :with_files, :with_links, question: question, author: other_user }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, question }
    it { should_not be_able_to :update, other_question }
    it { should be_able_to :update, answer }
    it { should_not be_able_to :update, other_answer }

    it { should be_able_to :destroy, question }
    it { should_not be_able_to :destroy, other_question }
    it { should be_able_to :destroy, answer }
    it { should_not be_able_to :destroy, other_answer }
    it { should be_able_to :destroy, question.files.first }
    it { should_not be_able_to :destroy, other_question.files.first }
    it { should be_able_to :destroy, answer.files.first }
    it { should_not be_able_to :destroy, other_answer.files.first }
    it { should be_able_to :destroy, question.links.first }
    it { should_not be_able_to :destroy, other_question.links.first }
    it { should be_able_to :destroy, answer.links.first }
    it { should_not be_able_to :destroy, other_answer.links.first }

    it { should be_able_to :best_answer, create(:answer, question: question, author: other_user) }
    it { should_not be_able_to :best_answer, create(:answer, question: other_question, author: user) }
    it { should_not be_able_to :best_answer, create(:answer, question: other_question, author: other_user) }

    it { should be_able_to :show_rewards, create(:reward, question: question, user: user) }
    it { should_not be_able_to :show_rewards, create(:reward, question: other_question, user: user) }
    it { should_not be_able_to :show_rewards, create(:reward, question: other_question, user: other_user) }
  end
end

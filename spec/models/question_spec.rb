require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:user) { create(:user) }
  let(:question) { create(:question, author: user) }

  it { should belong_to(:author).class_name('User') }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_one(:reward).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
  end

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :reward }

  it 'have many attached file' do
    expect(described_class.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
  
  describe 'set best answer' do
    let!(:answers) { create_list(:answer, 3, question: question, author: user) }

    it 'set the best answer' do
      question.set_best_answer(question.answers.second)
      question.set_best_answer(question.answers.first)

      expect(question.best_answer).to eq(question.answers.first)
      expect(question.best_answer).to_not eq(question.answers.second)
    end
  end

  describe 'database' do
    it { should have_db_index :title }
    it { should have_db_index :best_answer_id }
    it { should have_db_column(:best_answer_id).with_options(null: true) }
    it { should have_db_column(:best_answer_id).of_type(:integer) }
  end

  it_behaves_like 'votable'
end

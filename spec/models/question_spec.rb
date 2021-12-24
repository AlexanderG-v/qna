# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should have_many(:answers).dependent(:destroy) }

  describe 'validations' do
    subject { FactoryBot.build(:question) }
    it { should validate_uniqueness_of :title }
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
  end

  it { should have_db_index :title }
end

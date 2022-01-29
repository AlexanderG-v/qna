# frozen_string_literal: true

require 'rails_helper'
require Rails.root.join('spec/models/concerns/votable_spec.rb')

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to(:author).class_name('User') }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }

  it { should accept_nested_attributes_for :links }

  it { should validate_presence_of :body }

  it 'have many attached file' do
    expect(described_class.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it { should have_db_index :body }

  it_behaves_like 'votable'
end 

require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to(:author).class_name('User') }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }

  it { should accept_nested_attributes_for :links }

  it { should validate_presence_of :body }

  it_behaves_like 'have many attached file'

  it { should have_db_index :body }

  # it_behaves_like 'votable'
end 

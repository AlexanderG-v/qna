require 'rails_helper'

RSpec.describe Link, type: :model do
  let(:user) { create(:user) }
  let(:question) { create :question, author: user }
  let(:links) { create :link, linkable: question }
  let(:invalid_links) { build :link, :invalid, linkable: question }

  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it 'valid url' do
    expect(links).to be_valid
  end

  it 'invalid url' do
    expect(invalid_links).to_not be_valid
  end
end

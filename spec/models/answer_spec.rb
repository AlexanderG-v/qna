require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :questions }

  it { should validate_presence_of :body }
end

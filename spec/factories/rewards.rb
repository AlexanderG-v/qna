FactoryBot.define do
  factory :reward do
    name { 'MyReward' }
    association(:question)
  end
end

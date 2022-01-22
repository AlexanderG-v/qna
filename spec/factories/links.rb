FactoryBot.define do
  factory :link do
    association(:linkable)
    name { 'MyString' }
    url { 'https://github.com' }

    trait :invalid do
      name { 'Invalid link' }
      url { 'Invalid link' }
    end
  end
end

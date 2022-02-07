FactoryBot.define do
  factory :comment do
    body { "MyText" }

    user
    association(:commentable)

    trait :invalid do
      body { nil }
    end 
  end
end

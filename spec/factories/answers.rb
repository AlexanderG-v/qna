FactoryBot.define do
  factory :answer do
    body { "MyText" }
    question
    author { nil }

    trait :invalid do
      body { nil }
    end
  end
end

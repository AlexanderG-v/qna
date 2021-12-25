FactoryBot.define do
  factory :question do
    sequence(:title) { |n| "My#{n}String" }

    body { "MyText" }

    trait :invalid do
      title { nil }
    end
  end
end

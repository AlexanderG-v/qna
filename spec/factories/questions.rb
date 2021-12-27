FactoryBot.define do
  sequence :title do |n| 
    "My#{n}String"
  end
  factory :question do
    title
    body { "MyText" }

    trait :invalid do
      title { nil }
    end
  end
end

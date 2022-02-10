FactoryBot.define do
  factory :authorizantion do
    user { nil }
    provider { "MyString" }
    uid { "MyString" }
  end
end

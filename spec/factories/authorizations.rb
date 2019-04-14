FactoryBot.define do
  factory :authorization do
    user { nil }
    provider { "MyString" }
    uid { "MyString" }
  end

  trait :twitter_auth do
    association :user, factory: :user
    provider { "twitter" }
    uid { "123" }
  end
end

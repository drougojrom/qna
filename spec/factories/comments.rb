FactoryBot.define do
  factory :comment do
    body { "MyText" }
  end

  trait :invalid do
    body { nil }
  end
end

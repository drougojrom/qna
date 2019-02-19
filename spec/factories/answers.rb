FactoryBot.define do
  sequence :body do |n|
    "Text of answer body ##{n}"
  end

  factory :answer do
    body { "MyText" }
    question
    user

    factory :answer_sequence do
      body
    end

    trait :invalid do
      body { nil }
    end
  end
end

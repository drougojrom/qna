FactoryBot.define do
  factory :vote do
    user
    value { 1 }
    question
  end
end

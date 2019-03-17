FactoryBot.define do
  factory :vote do
    user
    value { 1 }
    association :votable, factory: :question
  end
end

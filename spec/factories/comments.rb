FactoryBot.define do
  factory :comment do
    reference { "" }
    reference { "" }
    body { "MyText" }
    polymorphic { "" }
  end
end

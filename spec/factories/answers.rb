include ActionDispatch::TestProcess

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

  factory :answer_with_attached_file, class: 'Answer' do
    body { "MyText" }
    question
    user
    files { fixture_file_upload "#{Rails.root}/spec/rails_helper.rb" }
  end
end

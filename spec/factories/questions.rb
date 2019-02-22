include ActionDispatch::TestProcess

FactoryBot.define do
  factory :question do
    title { "MyString" }
    body { "MyText" }
    user

    trait :invalid do
      title { nil }
    end
  end

  factory :question_with_answers, class: 'Question' do
    title { "MyString" }
    body { "MyText" }
    user
    after(:create) do |question|
      create_list(:answer_sequence, 5, question: question)
    end
  end

  factory :question_with_right_answers, class: 'Question' do
    title { "MyString" }
    body { "MyText" }
    user
    after(:create) do |question|
      create_list(:answer_sequence, 3, question: question, right_answer: true)
    end
  end

  factory :question_with_attached_file, class: 'Question' do
    title { "MyString" }
    body { "MyText" }
    user
    files { fixture_file_upload "#{Rails.root}/spec/rails_helper.rb" }
  end
end

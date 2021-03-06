include ActionDispatch::TestProcess

FactoryBot.define do
  factory :question do
    title { "MyString" }
    body { "MyText" }
    user

    trait :invalid do
      title { nil }
    end

    trait :with_link do
      after(:create) do |question|
        create :link, linkable: question
      end
    end

    trait :with_reward do
      after(:create) do |question|
       create :reward, question: question
      end
    end

    trait :with_comment do
      after(:create) do |question|
        create :comment, question: question
      end
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

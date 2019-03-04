FactoryBot.define do
  factory :link do
    name { "MyString" }
    url { "MyString" }
  end

  factory :questions_link, class: 'Link' do
    name { "MyString" }
    url { "MyString" }
  end
end

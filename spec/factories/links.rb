FactoryBot.define do
  factory :link do
    name { "MyString" }
    url { "https://mylink.com/asas" }
  end

  factory :questions_link, class: 'Link' do
    name { "MyString" }
    url { "https://mylink.com/asas" }
  end
end

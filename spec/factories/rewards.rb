FactoryBot.define do
  factory :reward do
    title { "My reward" }
    image { fixture_file_upload(Rails.root.join('spec', 'support', 'assets', 'test-image.png'), 'image/png') }
    question
    user
  end
end

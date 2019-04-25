FactoryBot.define do
  factory :file do
    file { File.new("#{Rails.root}/spec/spec_helper.rb") }
    attachable { nil }
  end
end

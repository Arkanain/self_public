FactoryGirl.define do
  factory :article do
    sequence(:title) { |n| "Article title #{n}" }
    sequence(:text) { |n| "Article text #{n}" }
  end
end
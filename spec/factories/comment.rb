FactoryGirl.define do
  factory(:comment) do
    sequence(:text) { |n| "Comment text #{n}" }
  end
end
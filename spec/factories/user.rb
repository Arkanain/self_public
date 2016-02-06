FactoryGirl.define do
  factory :admin, class: User do
    first_name 'admin'
    last_name 'admin'
    email { "#{first_name}@test.com" }
    role 'admin'
    password 'qqqqqq'
    password_confirmation 'qqqqqq'
  end

  factory :writer, class: User do
    first_name 'writer'
    last_name 'writer'
    email { "#{first_name}@test.com" }
    role 'writer'
    password 'qqqqqq'
    password_confirmation 'qqqqqq'
  end
end
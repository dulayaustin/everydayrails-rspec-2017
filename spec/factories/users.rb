FactoryBot.define do
  factory :user, aliases: [:owner] do
    first_name "Austin"
    last_name "Dulay"
    sequence(:email) { |n| "tester#{n}@example.com" }
    password "password"
  end
end

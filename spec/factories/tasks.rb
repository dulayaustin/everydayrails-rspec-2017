FactoryBot.define do
  factory :task do
    name { "Test task" }
    association :project
  end
end

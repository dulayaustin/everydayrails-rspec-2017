FactoryBot.define do
  factory :note do
    message "This is a sample note."
    association :project
    user { project.owner }
    # association :user      ### This will persist another user, because project factory also has association user (owner)
  end
end

require 'rails_helper'

RSpec.feature "Projects", type: :feature do
  # include LoginSupport ## To explicitly include support module

  scenario "user creates a new project" do
    user = FactoryBot.create(:user)
    # sign_in_as user   ## Custom helper module at spec/support/modules/login_support.rb
    sign_in user        ## Devise helper `config.include Devise::Test::IntegrationHelpers, type: :feature`

    visit root_path

    expect {
      click_link "New Project"
      fill_in "Name", with: "Test Project"
      fill_in "Description", with: "Trying out Capybara"
      click_button "Create Project"

    }.to change(user.projects, :count).by(1)

    aggregate_failures do
      expect(page).to have_content "Project was successfully created"
      expect(page).to have_content "Test Project"
      expect(page).to have_content "Owner: #{user.name}"
    end
  end
end

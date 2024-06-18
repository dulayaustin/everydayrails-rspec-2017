# For sharing steps on feature specs, `include LoginSupport` on a spec to include this explicitly

module LoginSupport
  def sign_in_as(user)
    visit root_path
    click_link "Sign in"
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"
  end
end

# RSpec.configure do |config|
#   config.include LoginSupport
# end
require 'rails_helper'

RSpec.describe "Projects API", type: :request do
  it "loads a project" do
    user = FactoryBot.create(:user)
    FactoryBot.create(:project, name: "Sample Project")
    FactoryBot.create(:project, owner: user, name: "Second Sample Project")

    get api_projects_path, params: {
      user_email: user.email,
      user_token: user.authentication_token
    }

    expect(response).to have_http_status(:success)
    json = JSON.parse(response.body)
    expect(json.length).to eq 1

    project_id = json[0]["id"]

    get api_projects_path(project_id), params: {
      user_email: user.email,
      user_token: user.authentication_token
    }

    expect(response).to have_http_status(:success)
    json = JSON.parse(response.body)
    expect(json.first["name"]).to eq "Second Sample Project"
  end

  it "creates a project" do
    user = FactoryBot.create(:user)
    project_params = FactoryBot.attributes_for(:project)

    expect {
      post api_projects_path, params: {
        user_email: user.email,
        user_token: user.authentication_token,
        project: project_params
      }
    }.to change(user.projects, :count).by(1)


    expect(response).to have_http_status(:success)
  end

  describe "GET /api/projects" do
    it "works! (now write some real specs)" do
      get api_projects_path
      expect(response).to have_http_status(200)
    end
  end
end

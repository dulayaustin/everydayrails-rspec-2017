require 'rails_helper'

RSpec.describe "Projects", type: :request do
  context "migrate from projects_controller specs to request specs" do
    describe "GET /projects" do
      context "as an authenticated user" do
        before do
          @user = FactoryBot.create(:user)
        end

        it "responds successfully" do
          sign_in @user
          get projects_path
          expect(response).to be_success
        end

        it "returns a 200 response" do
          sign_in @user
          get projects_path
          expect(response).to have_http_status "200"
        end
      end

      context "as a guest" do
        it "returns a 302 response" do
          get projects_path
          expect(response).to have_http_status "302"
        end

        it "redirects to the sign-in page" do
          get projects_path
          expect(response).to redirect_to "/users/sign_in"
        end
      end
    end

    describe "GET /projects/:id" do
      context "as an authorized user" do
        before do
          @user = FactoryBot.create(:user)
          @project = FactoryBot.create(:project, owner: @user)
        end

        it "responds successfully" do
          sign_in @user
          get project_path(@project)
          expect(response).to be_success
        end
      end

      context "as an unauthorized user" do
        before do
          @user = FactoryBot.create(:user)
          other_user = FactoryBot.create(:user)
          @project = FactoryBot.create(:project, owner: other_user)
        end

        it "redirects to the dashboard" do
          sign_in @user
          get project_path(@project)
          expect(response).to redirect_to root_path
        end
      end
    end

    describe "POST /projects" do
      context "as an authenticated user" do
        before do
          @user = FactoryBot.create(:user)
        end

        context "with valid attributes" do
          it "adds a project" do
            project_params = FactoryBot.attributes_for(:project)
            sign_in @user
            expect {
              post projects_path, params: { project: project_params }
            }.to change(@user.projects, :count).by(1)
          end
        end

        context "with invalid attributes" do
          it "does not adds a project" do
            project_params = FactoryBot.attributes_for(:project, :invalid)
            sign_in @user
            expect {
              post projects_path, params: { project: project_params }
            }.to_not change(@user.projects, :count)
          end
        end
      end

      context "as a guest" do
        it "returns a 302 response" do
          project_params = FactoryBot.attributes_for(:project)
          post projects_path, params: { project: project_params }
          expect(response).to have_http_status "302"
        end

        it "redirects to the sign-in page" do
          project_params = FactoryBot.attributes_for(:project)
          post projects_path, params: { project: project_params }
          expect(response).to redirect_to "/users/sign_in"
        end
      end
    end

    describe "PATCH /projects/:id" do
      context "as an authorized user" do
        before do
          @user = FactoryBot.create(:user)
          @project = FactoryBot.create(:project, owner: @user)
        end

        it "updates a project" do
          project_params = FactoryBot.attributes_for(:project,
            name: "New Project Name")
          sign_in @user
          patch project_path(@project), params: { project: project_params }
          expect(@project.reload.name).to eq "New Project Name"
        end
      end

      context "as an unauthorized user" do
        before do
          @user = FactoryBot.create(:user)
          other_user = FactoryBot.create(:user)
          @project = FactoryBot.create(:project,
            owner: other_user,
            name: "Same Old Name")
        end

        it "does not update the project" do
          project_params = FactoryBot.attributes_for(:project,
            name: "New Name")
          sign_in @user
          patch project_path(@project), params: { project: project_params }
          expect(@project.reload.name).to eq "Same Old Name"
        end

        it "redirects to the dashboard" do
          project_params = FactoryBot.attributes_for(:project)
          sign_in @user
          patch project_path(@project), params: { project: project_params }
          expect(response).to redirect_to root_path
        end
      end

      context "as a guest" do
        before do
          @project = FactoryBot.create(:project)
        end

        it "returns a 302 response" do
          project_params = FactoryBot.attributes_for(:project)
          patch project_path(@project), params: { project: project_params }
          expect(response).to have_http_status "302"
        end

        it "redirects to the sign-in page" do
          project_params = FactoryBot.attributes_for(:project)
          patch project_path(@project), params: { project: project_params }
          expect(response).to redirect_to "/users/sign_in"
        end
      end
    end

    describe "DELETE /projects/:id" do
      context "as an authorized user" do
        before do
          @user = FactoryBot.create(:user)
          @project = FactoryBot.create(:project, owner: @user)
        end

        it "deletes a project" do
          sign_in @user
          expect {
            delete project_path(@project)
          }.to change(@user.projects, :count).by(-1)
        end
      end

      context "as an unauthorized user" do
        before do
          @user = FactoryBot.create(:user)
          other_user = FactoryBot.create(:user)
          @project = FactoryBot.create(:project, owner: other_user)
        end

        it "does not delete the project" do
          sign_in @user
          expect {
            delete project_path(@project)
          }.to_not change(Project, :count)
        end

        it "redirects to the dashboard" do
          sign_in @user
          delete project_path(@project)
          expect(response).to redirect_to root_path
        end
      end

      context "as a guest" do
        before do
          @project = FactoryBot.create(:project)
        end

        it "returns a 302 response" do
          delete project_path(@project)
          expect(response).to have_http_status "302"
        end

        it "redirects to the sign-in page" do
          delete project_path(@project)
          expect(response).to redirect_to "/users/sign_in"
        end

        it "does not delete the project" do
          expect {
            delete project_path(@project)
          }.to_not change(Project, :count)
        end
      end
    end
  end
end

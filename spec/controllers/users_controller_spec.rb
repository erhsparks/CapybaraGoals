require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:username) { "users controller test user" }
  let(:password) { "password" }

  describe "GET #new" do
    it "renders the new user page" do
      get :new

      expect(response).to render_template("new")
      expect(response).to have_http_status(200)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "redirects to user show page" do
        post :create, user: { username: username, password: password }

        expect(response).to redirect_to(user_url(User.find_by_username(username)))
      end
    end

    context "with invalid params" do
      it "validates presence of username and password" do
        post :create, user: { username: "", password: "" }

        expect(response).to redirect_to(new_user_url)
        expect(flash[:errors]).to be_present
      end
    end
  end

  describe "GET #show" do
    context "with valid params" do
      it "renders correct user show page" do
        User.create!(username: username, password: password)

        get :show, id: (User.find_by_username(username))

        expect(response).to render_template("show")
        expect(response).to have_http_status(200)
      end
    end

    context "with invalid params" do
      it "does not render anything if user does not exist" do
        begin
          get :show, id: -1
        rescue
          ActiveRecord::RecordNotFound
        end

        expect(response).to_not render_template("show")
      end
    end
  end
end

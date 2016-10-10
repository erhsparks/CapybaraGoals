require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:username) { "session controller test user" }
  let(:password) { "password" }
  before(:each) { User.create(username: username, password: password) }

  describe "GET #new" do
    it "renders the login page" do
      get :new

      expect(response).to render_template("new")
      expect(response).to have_http_status(200)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "logs in a user" do
        post :create, user: { username: username, password: password }
        user = User.find_by_username(username)

        expect(session[:session_token]).to eq(user.session_token)
      end

      it "redirects to user show page" do
        post :create, user: { username: username, password: password }

        expect(response).to redirect_to(user_url(User.find_by_username(username)))
      end
    end

    context "with invalid params" do
      it "validates presence of username and password" do
        post :create, user: { username: "", password: "" }

        expect(response).to redirect_to(new_session_url)
        expect(flash[:errors]).to be_present
      end
    end
  end

  describe "DELETE #destroy" do
    it "logs out a user" do
      post :create, user: { username: username, password: password }

      delete :destroy

      expect(session[:session_token]).to be nil
    end

    it "redirects to login page" do
      post :create, user: { username: username, password: password }

      delete :destroy

      expect(response).to redirect_to(new_session_url)
    end
  end
end

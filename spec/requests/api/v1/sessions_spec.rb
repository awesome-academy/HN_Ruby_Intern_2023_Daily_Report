require "support/api_shared"

RSpec.describe API::V1::SessionsController, type: :controller do
  let(:account){create(:account)}

  describe "POST #authenticate" do
    before do |ex|
      post :authenticate, params: {
        account: account.slice(:email, :password).merge(
          ex.metadata[:invalid_pwd] ? {password: ""} : {})
      }
    end

    context "when success" do
      include_examples "json object", :ok, [:id, :token]
    end

    context "when fail" do
      context "with invalid authenticate params", :invalid_pwd do
        include_examples "json message", :bad_request, :authenticate_fail
      end
    end
  end

  describe "GET #me" do
    before do |ex|
      account.renew_api_token if ex.metadata[:renew]
      request.headers.merge!({"Authorization": "Bearer #{account.api_token}"})
      get :me
    end

    context "when authenticated", :renew do
      include_examples "json object", :ok, [:id, :email, :username]
    end

    context "when not authenticate" do
      include_examples "json message", :unauthorized, :bad_credentials
    end
  end
end

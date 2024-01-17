require "support/api_shared"

RSpec.describe API::V1::SessionsController, :api, type: :controller do
  let(:account){create(:account)}

  describe "POST #authenticate", :no_token do
    before do |ex|
      post :authenticate, params: {
        account: account.slice(:email, :password).merge(
          ex.metadata[:invalid_pwd] ? {password: ""} : {})
      }
    end

    context "when success" do
      let(:serialize_attributes){%w(id token)}

      include_examples "json object", :token
    end

    context "when fail" do
      context "with invalid authenticate params", :invalid_pwd do
        include_examples "json message", :authenticate_fail
      end
    end
  end

  describe "GET #me" do
    before do |ex|
      get :me
    end

    context "when authenticated" do
      let(:serialize_attributes){%w(id email username)}

      include_examples "json object", :account
    end

    context "when not authenticate", :no_token do
      include_examples "json message", :bad_credentials, status: :unauthorized
    end
  end
end

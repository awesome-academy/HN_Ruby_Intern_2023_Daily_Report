require "support/api_shared"

RSpec.describe API::V1::RegistrationsController, :api, type: :controller do
  describe "POST #register" do
    context "when account params is valid" do
      before do
        post :register, params: {
          account: {
            email: "test@example.com",
            password: "password",
            password_confirmation: "password",
            username: "testuser"
          }
        }
      end

      include_examples "json message", :register_check_email, status: :ok
    end

    context "when account params is not valid" do
      before do
        post :register, params: {
          account: {
            email: "test@example.com"
          }
        }
      end

      include_examples "json errors", :account, :create
    end
  end
end

require "rails_helper"

RSpec.shared_context "shared api" do
  let(:json_body){JSON.parse(response.body)}
  let(:account) do |ex|
    create(ex.metadata[:api_admin] ? :admin : :account)
  end

  before do |ex|
    unless ex.metadata[:no_token]
      account.renew_api_token unless account.api_token
      request.headers.merge!({"Authorization": "Bearer #{account.api_token}"})
    end
  end
end

RSpec.configure do |config|
  config.include_context "shared api", :api, :api_admin
end


RSpec.shared_examples "json status" do |status|
  it "responses with :#{status} status code" do
    expect(response).to have_http_status status
  end
end

RSpec.shared_examples "json message" do |message, status: :bad_request|
  include_examples "json status", status
  it "returns json message :#{message}" do
    expect(json_body["message"]).to eq I18n.t("api.#{message}")
  end
end

RSpec.shared_examples "json object" do |name, status: :ok|
  include_examples "json status", status

  it "returns :#{name} object with proper keys" do
    expect(json_body.keys).to include *serialize_attributes
  end
end

RSpec.shared_examples "json collection" do |name, size, status: :ok|
  include_examples "json status", status

  it "returns :#{name} array with proper size" do
    expect(json_body.length).to match size
  end

  it "returns :#{name} array with proper keys" do
    expect(json_body[0].keys).to include *serialize_attributes
  end
end

RSpec.shared_examples "json errors" do |name, action, status: :unprocessable_entity|
  include_examples "json status", status

  it "returns :#{action}_fail message for notification" do
    expect(json_body["message"]).to eq I18n.t("api.#{action}_fail", name: I18n.t("#{name}s._name"))
  end

  it "returns errors array for detailed" do
    expect(json_body["errors"]).to match assigns(name).errors.full_messages
  end
end

require "rails_helper"

RSpec.shared_examples "json status" do |status|
  it "responses with :#{status} status code" do
    expect(response).to have_http_status status
  end
end

RSpec.shared_examples "json message" do |status, message|
  include_examples "json status", status
  it "returns json message :#{message}" do
    expect(JSON.parse(response.body)["message"]).to eq I18n.t(message)
  end
end

RSpec.shared_examples "json object" do |status, keys|
  include_examples "json status", status
  it "returns json object with keys: #{keys.join(", ")}" do
    expect(JSON.parse(response.body).keys).to include *keys.map(&:to_s)
  end
end

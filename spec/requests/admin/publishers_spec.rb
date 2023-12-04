require 'rails_helper'

RSpec.describe "Admin::Publishers", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/admin/publishers/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/admin/publishers/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/admin/publishers/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/admin/publishers/show"
      expect(response).to have_http_status(:success)
    end
  end

end

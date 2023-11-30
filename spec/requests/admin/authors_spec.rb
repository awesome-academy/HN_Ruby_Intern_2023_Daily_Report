require 'rails_helper'

RSpec.describe "Admin::Authors", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/admin/authors/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/admin/authors/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/admin/authors/edit"
      expect(response).to have_http_status(:success)
    end
  end

end

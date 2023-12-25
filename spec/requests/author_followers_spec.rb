require 'rails_helper'

RSpec.describe "AuthorFollowers", type: :request do
  describe "GET /create" do
    it "returns http success" do
      get "/author_followers/create"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /delete" do
    it "returns http success" do
      get "/author_followers/delete"
      expect(response).to have_http_status(:success)
    end
  end

end

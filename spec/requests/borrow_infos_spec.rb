require 'rails_helper'

RSpec.describe "BorrowInfos", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/borrow_infos/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/borrow_infos/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/borrow_infos/new"
      expect(response).to have_http_status(:success)
    end
  end

end

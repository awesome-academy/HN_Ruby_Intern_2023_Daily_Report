require "rails_helper"

RSpec.describe AccountsController, type: :controller do
  let(:account) { create(:account, password: "123456") }

  before do
    allow(controller).to receive(:authenticate_account!).and_return(true)
    allow(controller).to receive(:current_account).and_return(account)
  end

  describe "GET #show" do
    context "when favorite authors are present" do
      let(:authors) { create_list(:author, 3) }

      before do
        account.favorite_authors = authors
        get :show, params: { id: account.id }
      end

      it "assigns authors" do
        expect(assigns(:authors)).to match_array(authors)
      end
    end

    context "when favorite authors are blank" do
      before do
        account.favorite_authors = []
        get :show, params: { id: account.id }
      end

      it "does not assign authors" do
        expect(account.favorite_authors).to eq([])
      end
    end
  end


  describe "GET #edit" do
    context "when account is valid" do
      before { get :edit, params: { id: account.id } }

      it "builds new user_info if nil" do
        expect(assigns(:account).user_info).not_to be_nil
      end
    end

    context "when account is not valid" do
      before { get :edit, params: { id: -1 } }

      it_behaves_like "displays flash message", :warning, "account_not_found"

      it "redirects to root page" do
        expect(response).to redirect_to root_path
      end
    end

    context "when account is not current account" do
      let(:other_account) { create(:account) }

      before do
        allow(controller).to receive(:current_account).and_return(other_account)
        get :edit, params: { id: account.id }
      end

      it_behaves_like "displays flash message", :warning, "account_not_found"

      it "redirects to root page" do
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "PUT #update" do
    context "with valid attributes" do
      let(:valid_attributes) do
        {
          username: "new_username",
          current_password: "123456"
        }
      end

      it "updates the account" do
        put :update, params: { id: account.id, account: valid_attributes }
        account.reload
        expect(account.username).to eq("new_username")
      end
    end

    context "with invalid attributes" do
      let(:invalid_attributes) do
        {
          email: "invalid_email",
          current_password: "123456"
        }
      end

      it "does not update the account" do
        put :update, params: { id: account.id, account: invalid_attributes }
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
end

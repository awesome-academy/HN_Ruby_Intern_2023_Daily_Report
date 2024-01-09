require "rails_helper"

RSpec.describe BorrowInfosController, type: :controller do
  let(:account) { create(:account) }
  let(:cart) { create(:cart) }
  let(:borrow_info1) { create(:borrow_info, account: account) }
  let(:borrow_infos) { create_list(:borrow_info, 3, account: account) }

  before do
    allow(controller).to receive(:authenticate_account!).and_return(true)
  end

  describe "GET #index" do
    before do
      allow(controller).to receive(:current_account).and_return(account)
      get :index
    end

    it "assigns @borrow_infos" do
      expect(assigns(:borrow_infos_sort)).to match_array(borrow_infos)
    end
  end

  describe "GET #show" do
    context "when borrow info found" do
      before { get :show, params: {id: borrow_info1.id} }

      it "assigns @borrow_info" do
        expect(assigns(:borrow_info)).to eq(borrow_info1)
      end
    end

    context "when borrow info not found" do
      before { get :show, params: {id: -1} }

      it_behaves_like "displays flash message", :warning, "borrow_info_not_found"

      it_behaves_like "redirects to", :borrow_infos_path
    end
  end

  describe "GET #new" do
    before do
      allow(controller).to receive(:set_cart) { @controller.instance_variable_set(:@cart, cart) }
      allow(controller).to receive(:check_cart_empty).and_return(true)
      allow(controller).to receive(:check_user_info).and_return(true)
      get :new
    end

    it "assigns a new BorrowInfo to @borrow_info" do
      expect(assigns(:borrow_info)).to be_a_new(BorrowInfo)
    end

    it "renders the :new template" do
      expect(response).to render_template :new
    end
  end

  describe "POST #create" do
    before do
      allow(controller).to receive(:check_user_info).and_return(true)
      allow(controller).to receive(:current_account).and_return(account)
    end

    context "with valid attributes" do
      before do
        post :create, params: { borrow_info: { start_at: Date.current + 2, end_at: Date.current + 10 } }
      end

      it "creates a new borrow info" do
        expect(BorrowInfo.count).to eq 1
      end

      it_behaves_like "displays flash message", :success, "borrow_info_success"

      it "redirects to the new borrow info" do
        expect(response).to redirect_to(BorrowInfo.last)
      end
    end

    context "with invalid attributes" do
      before do
        post :create, params: { borrow_info: { start_at: "", end_at: "" } }
      end

      it "renders the :new template" do
        expect(response).to render_template(:new)
      end

      it "has bad request status" do
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe "#handle_status_action" do
    before do
      allow(controller).to receive(:current_account).and_return(account)
      allow(controller).to receive(:check_user_info).and_return(true)
      allow(controller).to receive(:correct_account).and_return(true)
    end

    context "when status is match the case pending" do
      let(:borrow_info){create(:borrow_info, :pending)}
      before { post :handle_status_action,  params: { id: borrow_info.id, status: "pending" } }

      it_behaves_like "displays flash message", :success, "cancel_request_successfully"
    end

    context "when status is match the case approved" do
      let(:borrow_info){create(:borrow_info, :approved)}
      before do
        patch :handle_status_action, params: { id: borrow_info.id, status: "approved", borrow_info: { renewal_at: borrow_info.end_at + 15 } }
      end

      context "when renew request is false" do
        it "renders the :show template" do
          expect(response).to render_template(:show)
        end

        it "has bad request status" do
          expect(response).to have_http_status(:bad_request)
        end
      end
    end

    context "when status is match the case renewing" do
      let(:borrow_info){create(:borrow_info, :renewing)}
      before { post :handle_status_action,  params: { id: borrow_info.id, status: "renewing" } }

      it_behaves_like "displays flash message", :success, "cancel_request_successfully"
    end

    context "when status is not match the case" do
      let(:borrow_info){create(:borrow_info)}
      before { post :handle_status_action,  params: { id: borrow_info.id, status: "" } }

      it_behaves_like "displays flash message", :danger, "unknown_status_request"
    end
  end

  describe "GET #download" do
    before do
      allow(controller).to receive(:current_account).and_return(account)
      allow(controller).to receive(:check_user_info).and_return(true)
      allow(controller).to receive(:correct_account).and_return(true)
      get :download, params: { id: borrow_info1.id }
    end

    it "has a disposition of attachment" do
      expect(response.headers["Content-Disposition"]).to include("attachment; filename=")
    end

    it "sends a PDF file" do
      expect(response.content_type).to eq "application/pdf"
    end
  end

  describe "GET #preview" do
    before do
      allow(controller).to receive(:current_account).and_return(account)
      allow(controller).to receive(:check_user_info).and_return(true)
      allow(controller).to receive(:correct_account).and_return(true)
      get :preview, params: { id: borrow_info1.id }
    end

    it "has a disposition of inline" do
      expect(response.headers["Content-Disposition"]).to include("inline; filename=")
    end

    it "sends a PDF file" do
      expect(response.content_type).to eq "application/pdf"
    end
  end
end

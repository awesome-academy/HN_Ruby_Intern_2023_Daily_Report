require "rails_helper"

RSpec.describe NotificationsController, type: :controller do
  let(:account) { create(:account) }
  let(:account2) { create(:account) }
  let(:notification1) { create(:notification, content: "info", status: 0, link: "http://example.com", account: account) }
  let(:notification2) { create(:notification, content: "notice", status: 1, account: account) }
  let!(:notifications) { [notification1, notification2] }

  before { allow(controller).to receive(:authenticate_account!).and_return(true) }

  describe "GET #index" do
    context "if account has notifications" do
      before do
        allow(controller).to receive(:current_account).and_return(account)
        get :index, as: :turbo_stream
      end

      it "assigns @notifications" do
        expect(assigns(:notifications)).to match_array(notifications)
      end
    end

    context "if account not have notifications" do
      before do
        allow(controller).to receive(:current_account).and_return(account2)
        get :index, as: :turbo_stream
      end

      it "assigns @notifications" do
        expect(assigns(:notifications)).to match_array([])
      end
    end
  end

  describe "POST #read_all" do
    before { post :read_all }

    it "marks all notifications as read" do
      expect(Notification.unchecked.count).to eq(0)
    end

    it_behaves_like "redirects to", :root_path
  end

  describe "PATCH #update" do
    context "when notification has a link" do
      before { patch :update, params: { id: notification1.id } }

      it "updates the notification" do
        expect(notification1.reload.checked).to be true
      end

      it "redirects to the link" do
        expect(response).to redirect_to(notification1.link)
      end
    end

    context "when notification does not have a link" do
      before { patch :update, params: { id: notification2.id } }

      it "updates the notification" do
        expect(notification2.reload.checked).to be true
      end

      it_behaves_like "redirects to", :root_path
    end

    context "when notification does not exist" do
      before { patch :update, params: { id: -1 } }

      it "updates the notification" do
        expect(assigns(:notification)).to eq(nil)
      end
    end
  end
end

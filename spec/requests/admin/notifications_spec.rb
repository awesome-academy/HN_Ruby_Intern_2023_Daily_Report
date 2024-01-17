require "support/admin_shared"

RSpec.describe Admin::NotificationsController, :admin, type: :controller do
  let(:notification){create(:notification, account: admin)}
  before do
    create_list(:notification, 2, account: create(:account))
    create_list(:notification, 2, account: admin)
  end

  describe "GET #index" do
    before do
      get :index, params: {format: :turbo_stream}
    end

    it "populates array of admin Notification to @notifications" do
      expected = Notification.for_me(admin).created_order
      expect(expected).to start_with *assigns(:notifications)
    end

    it "renders :index template" do
      should render_template :index
    end
  end

  describe "POST #read_all" do
    before do
      post :read_all, params: {format: :turbo_stream}
    end
    it "set checked for all unchecked notifications" do
      expect(Notification.for_me(admin).unchecked.count).to eq 0
    end

    it "does not set checked for other user notifications" do
      expect(Notification.unchecked.count).to eq 2
    end
  end

  describe "PATCH #update" do
    before do |ex|
      patch :update, params: {id: ex.metadata[:not_found] ? -1 : notification.id}
    end

    it "assigns the requested notification to @notification" do
      expect(assigns(:notification)).to eq notification
    end

    context "when notification is not found", :not_found do
      it "renders nothing" do
        expect(response.body).to be_blank
      end
    end

    context "when notification is found" do
      it "set checked for this notification" do
        expect(notification.reload.checked).to be_truthy
      end

      context "with link inside" do
        let(:notification){create(:notification, account: admin, link: admin_root_path)}
        it "redirects to the link path" do
          should redirect_to notification.link
        end
      end

      context "with no link" do
        it "renders nothing" do
          expect(response.body).to be_blank
        end
      end
    end
  end
end

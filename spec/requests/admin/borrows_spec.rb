require "support/admin_shared"

RSpec.describe Admin::BorrowsController, :admin, type: :controller do
  let(:borrow){create(:borrow_info)}

  shared_examples "populate borrow" do
    it "assigns the requested borrow to @borrow" do
      expect(assigns(:borrow)).to eq borrow
    end
  end

  shared_examples "notifies to borrower" do |action|
    before do
      post action, params: {id: borrow.id, format: :turbo_stream, reject_reason: ("A Reason" if action == :reject)}
      @last_notif = borrow.account.notifications.last
    end

    describe "creates new notification for borrower" do
      it "with content indicate the borrow status" do
        notif_key = {
          approve: :approved,
          reject: :rejected,
          return: :returned_overdue,
          remind: :remind
        }[action]
        expected = "notifications.borrow_#{notif_key}"
        expect(@last_notif&.content).to eq expected
      end

      it "with link point to the borrow" do
        expect(@last_notif&.link).to eq borrow_info_path(borrow)
      end
    end
  end

  shared_examples "change borrow status" do |action, result|
    before do
      @group = action == :return ? :borrowing : :pending
      post action, params: {id: borrow.id, format: :turbo_stream, reject_reason: ("A Reason" if action == :reject)}
    end

    include_examples "set flash", result, "#{action}_borrow_#{result}"

    it "redirects to borrows list page with proper group" do
      should redirect_to admin_borrows_path(group: @group)
    end
  end

  shared_examples "populate borrows by group" do |group|
    context "with #{group} group" do
      before do
        get :index, params: {group:}
      end

      it "populates array of BorrowInfo to @borrows" do
        expected = BorrowInfo.send(group == :pending ? :waiting : group)
                             .includes_user.newest
        expect(assigns(:borrows)).to match expected.to_a
      end

      it "renders :index template" do
        should render_template :index
      end
    end
  end

  describe "GET #index" do
    before do
      create_list(:borrow_info, 6)
    end

    include_examples "populate borrows by group", :pending
    include_examples "populate borrows by group", :history
    include_examples "populate borrows by group", :borrowing
  end

  describe "GET #show" do
    context "when borrow is not found" do
      before do
        get :show, params: {id: -1}
      end
      include_examples "invalid item", :borrow
    end

    context "when borrow is found" do
      before do
        get :show, params: {id: borrow.id}
      end

      include_examples "populate borrow"

      it "populates books in this borrow request" do
        expected = borrow.books.remain_least.with_attached_image
        expect(assigns(:books)).to match expected.to_a
      end

      it "renders the :tab_books template" do
        should render_template "admin/shared/tab_books"
      end
    end
  end

  describe "POST #approve" do
    context "with valid borrow request" do
      let(:borrow){create(:borrow_info, :pending)}

      it_behaves_like "change borrow status", :approve, :success
      it_behaves_like "notifies to borrower", :approve
    end

    context "with invalid borrow request" do
      context "when borrow status is invalid for approving" do
        let(:borrow){create(:borrow_info, :rejected)}
        it_behaves_like "change borrow status", :approve, :error
      end

      context "when has some book that is not available" do
        let(:borrow){create(:borrow_info, :pending, borrowable: false)}
        it_behaves_like "change borrow status", :approve, :error
      end
    end
  end

  describe "POST #reject" do
    context "with valid borrow request" do
      let(:borrow){create(:borrow_info, :pending)}

      context "and with reject reason" do
        it_behaves_like "change borrow status", :reject, :success, {reject_reason: "Some Reason"}
        it_behaves_like "notifies to borrower", :approve
      end

      context "and with no reject reason" do
        before do
          post :reject, params: {id: borrow.id, reject_reason: "", format: :turbo_stream}
        end

        include_examples "set flash", :warning, :require_reject_reason, now: true
        it "render :notify partial" do
          should render_template(partial: "admin/shared/_notify")
        end
      end
    end
  end

  describe "POST #return" do
    context "with valid borrow request" do
      let(:borrow){create(:borrow_info, :approved, borrowable: true)}
      it_behaves_like "change borrow status", :return, :success

      context "when the borrow is overdue" do
        before do
          borrow.update_column :end_at, Time.zone.yesterday
        end
        it_behaves_like "notifies to borrower", :return
      end
    end

    context "with invalid borrow request" do
      context "when has some book that is invalid of borrowed count" do
        it_behaves_like "change borrow status", :return, :error
      end
    end
  end

  describe "POST #remind" do
    before do
      post :remind, params: {id: borrow.id, format: :turbo_stream}
    end
    it_behaves_like "notifies to borrower", :remind

    include_examples "set flash", :success, :send_remind_email_success, now: true

    it "render :notify partial" do
      should render_template(partial: "admin/shared/_notify")
    end
  end
end

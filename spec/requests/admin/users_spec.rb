require "support/admin_shared"

RSpec.describe Admin::UsersController, :admin, type: :controller do
  let(:user){create(:account)}

  shared_examples "populate user" do
    it "assigns the requested user to @user" do
      expect(assigns(:user)).to eq user
    end
  end

  shared_examples "change status" do |to_active, more_params = {}|
    let(:status) {to_active ? :active : :inactive}

    context "when success" do
      before do
        @user = to_active ? create(:inactive_account) : create(:account)
        post status, params: {id: @user.id}.merge(more_params)
      end

      it "changes user status" do
        expect(@user.reload.is_active).to eq to_active
      end

      context "with turbo_stream format" do
        before do
          post status, params: {id: @user.id, format: :turbo_stream}.merge(more_params)
        end

        include_examples "set flash", :success,
                         "#{to_active ? :active : :inactive}_user_success",
                         now: true

        it "renders :change_status partial" do
          should render_template :change_status
        end
      end

      context "with html format" do
        include_examples "set flash", :success,
                         "#{to_active ? :active : :inactive}_user_success"

        it "redirects to users list page" do
          should redirect_to admin_users_path
        end
      end
    end

    context "when fail" do
      before do
        @user = to_active ? create(:account) : create(:inactive_account)
        post status, params: {id: @user.id, format: :turbo_stream}.merge(more_params)
      end

      it "keeps user status" do
        expect(@user.reload.is_active).to eq to_active
      end

      include_examples "set flash", :error, :update_user_status_error, now: true

      it "renders :change_status partial" do
        should render_template :change_status
      end
    end
  end

  describe "GET #index" do
    before do
      create_list(:user_info, 2)
      create_list(:not_activated_account, 2)
      get :index
    end

    it "populates array of Account to @users" do
      expected = Account.exclude(admin).only_activated.includes_info.newest
      expect(expected).to start_with *assigns(:users)
    end

    it "renders :index template" do
      should render_template :index
    end
  end

  describe "GET #show" do
    context "when user is not found" do
      before do
        get :show, params: {id: -1}
      end
      include_examples "invalid item", :user, :account
    end

    context "when user is activated" do
      before do
        get :show, params: {id: user.id}
      end
      include_examples "populate user"

      it "assigns @tab_id to :user_profile" do
        expect(assigns(:tab_id)).to eq :user_profile
      end

      it "renders the :tab_profile template" do
        should render_template :tab_profile
      end
    end

    context "when user not activated" do
      before do
        get :show, params: {id: create(:not_activated_account).id}
      end
      include_examples "invalid item", :user, :account
    end
  end

  describe "POST #active" do
    before do
      post :active, params: {id: user.id}
    end

    include_examples "populate user"
    include_examples "change status", true
  end

  describe "POST #inactive" do
    context "with reason" do
      before do
        post :inactive, params: {id: user.id, reason: "A Reason"}
      end

      include_examples "populate user"
      include_examples "change status", false, {reason: "A Reason"}
    end

    context "without reason" do
      before do
        post :inactive, params: {id: user.id, format: :turbo_stream}
      end

      include_examples "set flash", :warning, "require_lock_reason", now: true

      it "render :notify partial" do
        should render_template(partial: "admin/shared/_notify")
      end
    end
  end
end

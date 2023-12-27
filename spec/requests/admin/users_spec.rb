require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let(:admin){create(:admin)}
  let(:user){create(:account)}

  before do
    allow(controller).to receive(:authenticate_admin_account!).and_return(true)
    allow(controller).to receive(:current_admin_account).and_return(admin)
  end

  shared_examples "populate user" do
    it "assigns the requested user to @user" do
      expect(assigns(:user)).to eq user
    end
  end

  shared_examples "change status as turbo_stream" do |to_active, more_params = {}|
    context "when success" do
      before do
        @user = to_active ? create(:inactive_account) : create(:account)
        post (to_active ? :active : :inactive), params: {id: @user.id, format: :turbo_stream}.merge(more_params)
      end

      it "changes user status" do
        expect(@user.reload.is_active).to eq to_active
      end
      it "set flash.now message to success" do
        key = to_active ? :active : :inactive
        should set_flash.now[:success].to I18n.t("admin.notif.#{key}_user_success")
      end
      it "renders :change_status partial" do
        should render_template :change_status
      end
    end

    context "when fail" do
      before do
        @user = to_active ? create(:account) : create(:inactive_account)
        post (to_active ? :active : :inactive), params: {id: @user.id, format: :turbo_stream}.merge(more_params)
      end

      it "keep user status" do
        expect(@user.reload.is_active).to eq to_active
      end
      it "set flash.now message to error" do
        should set_flash.now[:error].to I18n.t("admin.notif.update_user_status_error")
      end
      it "renders :change_status partial" do
        should render_template :change_status
      end
    end
  end

  shared_examples "invalid user" do
    it "set flash message to error" do
      should set_flash[:error].to I18n.t("admin.notif.item_not_found", name: I18n.t("accounts._name"))
    end
    it "redirects to users list path" do
      should redirect_to admin_users_path
    end
  end

  describe "GET #index" do
    before do
      create_list(:user_info, 5)
      create_list(:not_activated_account, 2)
      get :index
    end

    it "populates array of Account to @users" do
      expected = Account.exclude(admin).only_activated.includes_info.newest
      expect(assigns(:users)).to match expected.to_a
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
      include_examples "invalid user"
    end

    context "when user is activated" do
      before do
        get :show, params: {id: user.id}
      end
      include_examples "populate user"

      it "assigns @tab_id to :user_profile" do
        expect(assigns(:tab_id)).to eq :user_profile
      end

      it "renders the :show template" do
        should render_template :tab_profile
      end
    end

    context "when user not activated" do
      before do
        get :show, params: {id: create(:not_activated_account).id}
      end
      include_examples "invalid user"
    end
  end

  describe "POST #active as turbo_stream" do
    before do
      post :active, params: {id: user.id, format: :turbo_stream}
    end

    include_examples "populate user"
    include_examples "change status as turbo_stream", true
  end

  describe "POST #inactive as turbo_stream" do
    context "with reason" do
      before do
        post :inactive, params: {id: user.id, format: :turbo_stream, reason: "A Reason"}
      end

      include_examples "populate user"
      include_examples "change status as turbo_stream", false, {reason: "A Reason"}
    end

    context "without reason" do
      before do
        post :inactive, params: {id: user.id, format: :turbo_stream}
      end
      it "set flash message to warning" do
        should set_flash[:warning].to I18n.t("admin.notif.require_lock_reason")
      end
      it "render :notify partial as turbo_stream" do
        should render_template(partial: "admin/shared/_notify")
      end
    end
  end
end

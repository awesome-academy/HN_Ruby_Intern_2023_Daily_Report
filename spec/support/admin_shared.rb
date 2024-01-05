require "rails_helper"
require "support/mailer_matcher"
require "support/model_matcher"

RSpec.shared_context "shared admin controller" do
  let(:admin){create(:admin)}

  before do
    allow(controller).to receive(:authenticate_admin_account!).and_return(true)
    allow(controller).to receive(:current_admin_account).and_return(admin)
  end
end

RSpec.configure do |config|
  config.include_context "shared admin controller", :admin, type: :controller
end

RSpec.shared_examples "invalid item" do |name, model_name = nil|
  model_name = name unless model_name
  it "set flash message to error" do
    should set_flash[:error].to I18n.t("admin.notif.item_not_found", name: I18n.t("#{model_name}s._name"))
  end
  it "redirects to #{name}s list path" do
    should redirect_to public_send("admin_#{name}s_path")
  end
end

RSpec.shared_examples "set flash" do |type, key, now: false, **key_options|
  if now
    it "set flash now message to #{type}" do
      should set_flash.now[type].to I18n.t("admin.notif.#{key}", **key_options)
    end
  else
    it "set flash message to #{type}" do
      should set_flash[type].to I18n.t("admin.notif.#{key}", **key_options)
    end
  end
end

RSpec.shared_examples "check errors" do |assign_key, name, *keys|
  it "set errors on #{name}" do
    expect(assigns(assign_key).errors.messages.keys).to include(*keys)
  end
end

RSpec.shared_examples "CRUD" do |name|
  let(name){create(name)}
  let("#{name}_params"){attributes_for(name)}

  before do
    create_list(:book_full_info, 5)
  end

  shared_examples "populate #{name}" do
    it "assigns the requested #{name} to @#{name}" do
      expect(assigns(name)).to eq send(name)
    end
  end

  describe "GET #index" do
    before do
      create_list(name, 3)
      get :index
    end

    it "populates array of #{name}s to @#{name}s" do
      expected = send(name).class.newest
      expect(expected).to start_with *assigns("#{name}s")
    end

    it "renders :index template" do
      should render_template :index
    end
  end

  describe "GET #show" do
    context "when #{name} is not found" do
      before do
        get :show, params: {id: -1}
      end
      include_examples "invalid item", name
    end

    context "when #{name} is found" do
      before do
        get :show, params: {id: send(name).id}
      end

      include_examples "populate #{name}"

      it "assigns @tab_id to :#{name}_books" do
        expect(assigns(:tab_id).to_s).to eq "#{name}_books"
      end

      it "populates @books" do
        expected = send(name).books.newest.with_attached_image
        expect(expected).to start_with *assigns(:books)
      end

      it "renders :tab_books template" do
        should render_template "admin/shared/tab_books"
      end
    end
  end

  describe "GET #new" do
    before do
      get :new
    end

    it "assigns @#{name} to new #{name}" do
      expect(assigns(name)).to be_a_clone_of send(name).class.new
    end

    it "renders the :edit template" do
      should render_template :edit
    end
  end

  describe "GET #edit" do
    before do
      get :edit, params: {id: send(name).id}
    end

    include_examples "populate #{name}"

    it "renders the :edit template" do
      should render_template :edit
    end
  end

  describe "POST #create" do
    context "when params are valid" do
      before do
        post :create, params: {name => send("#{name}_params")}
      end

      it "assigns the new #{name} created from parameters to @#{name}" do
        expect(assigns(name)).to be_a_clone_of send(name).class.new send("#{name}_params")
      end

      it "saves the #{name} to database" do
        expect(assigns(name)).to be_persisted
      end

      include_examples "set flash", :success, :create_success, name: I18n.t("#{name}s._name")

      it "redirects to #{name}s list page" do
        should redirect_to send("admin_#{name}s_path")
      end
    end

    context "when params are not valid" do
      before do |ex|
        post :create, params: {
          name => send("#{name}_params").merge({name: nil}),
          format: ex.metadata[:turbo] ? :turbo_stream : :html
        }
      end

      include_examples "check errors", name, "@#{name}", :name

      context "with turbo_stream format", :turbo do
        it "renders the :form_fail partial" do
          should render_template "admin/shared/_form_fail"
        end
      end

      context "with html format" do
        it "renders the :edit template" do
          should render_template :edit
        end
      end
    end
  end

  describe "PATCH #update" do
    before do
      patch :update, params: {id: send(name).id, name => send("#{name}_params")}
    end

    context "when params are valid" do
      it "changes the #{name} attributes" do
        expect(assigns(name).reload.attributes).to include(send("#{name}_params").transform_keys(&:to_s))
      end

      include_examples "set flash", :success, :update_success, name: I18n.t("#{name}s._name")

      it "redirects to #{name}s list page" do
        should redirect_to send("admin_#{name}s_path")
      end
    end
  end

  describe "DELETE #destroy" do
    before do
      delete :destroy, params: {id: send(name).id, format: :turbo_stream}
    end

    context "when destroy successfully" do
      include_examples "set flash", :success, :delete_success, name: I18n.t("#{name}s._name")
    end

    it "redirects to #{name}s list page" do
      redirect_to send("admin_#{name}s_path")
    end
  end
end

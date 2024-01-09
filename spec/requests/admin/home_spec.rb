require "support/admin_shared"

RSpec.describe Admin::HomeController, :admin, type: :controller do
  describe "GET #index" do
    before do
      get :index, params: {period: :week}
    end

    it "assigns @period" do
      expect(assigns(:period)).to eq :week
    end
  end

  describe "GET #export_library" do
    before do
      get :export_library, params: {format: :xlsx}
    end

    it "populates @books" do
      expect(assigns(:books)).to eq Book.includes_info
    end
    it "populates @publishers" do
      expect(assigns(:publishers)).to eq Publisher.all
    end
    it "populates @authors" do
      expect(assigns(:authors)).to eq Author.with_attached_avatar
    end
    it "populates @genres" do
      expect(assigns(:genres)).to eq Genre.all
    end
    it "renders :export_library template" do
      should render_template :export_library
    end
  end
end

require "rails_helper"

RSpec.describe CartsController, type: :controller do
  let(:cart) { create(:cart) }
  let(:current_cart) { create(:cart) }

  before do
    allow(controller).to receive(:authenticate_account!).and_return(true)
    allow(controller).to receive(:set_cart) { @controller.instance_variable_set(:@cart, cart) }
    allow(controller).to receive(:check_cart_empty).and_return(true)
    allow(controller).to receive(:check_user_info).and_return(true)
    session[:cart_id] = cart.id
  end

  describe "GET #show" do
    it "renders the show template" do
      get :show
      expect(response).to render_template(:show)
    end
  end

  describe "DELETE #destroy" do
    context "when cart is not empty" do
      before { delete :destroy, params: { id: cart.id } }

      it "destroys the cart" do
        expect(Cart.find_by(id: cart.id)).to be_nil
      end

      it "sets session[:cart_id] to nil" do
        expect(session[:cart_id]).to be_nil
      end

      it_behaves_like "displays flash message", :success, "empty_cart_successfully"

      it_behaves_like "redirects to", :carts_path
    end
  end
end

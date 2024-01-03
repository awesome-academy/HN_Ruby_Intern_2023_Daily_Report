require "rails_helper"

RSpec.describe Accounts::SessionsController, type: :controller do
  let(:account) { create(:account) }
  let(:cart) { create(:cart) }

  before(:each) do
    sign_in account
    request.env["devise.mapping"] = Devise.mappings[:account]
    session[:cart_id] = cart.id
  end

  describe "DELETE #destroy" do
    before { delete :destroy }

    it "destroys the cart" do
      expect(Cart.find_by(id: cart.id)).to be_nil
    end

    it "sets cart session to nil" do
      expect(session[:cart_id]).to be_nil
    end
  end
end

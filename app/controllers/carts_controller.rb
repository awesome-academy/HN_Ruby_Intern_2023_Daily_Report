class CartsController < ApplicationController
  include CartActions

  before_action :require_login
  before_action :set_cart
  before_action :check_cart_empty, only: %i(destroy)

  def show; end

  def destroy
    @cart.destroy
    session[:cart_id] = nil
    redirect_to carts_path
  end
end

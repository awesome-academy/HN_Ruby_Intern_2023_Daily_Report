class CartsController < ApplicationController
  before_action :require_login
  before_action :set_cart

  def show; end

  def destroy
    @cart.destroy
    session[:cart_id] = nil
    redirect_to carts_path
  end

  private

  def set_cart
    @cart = @current_cart
  end
end

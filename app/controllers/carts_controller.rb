class CartsController < ApplicationController
  include CartActions

  before_action :authenticate_account!
  before_action :set_cart
  before_action :check_cart_empty, only: %i(destroy)
  before_action :check_user_info

  def show; end

  def destroy
    @cart.destroy
    session[:cart_id] = nil

    flash[:success] = t "empty_cart_successfully"
    redirect_to carts_path
  end
end

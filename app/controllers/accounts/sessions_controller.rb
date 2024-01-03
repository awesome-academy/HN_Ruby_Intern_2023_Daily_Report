class Accounts::SessionsController < Devise::SessionsController
  def destroy
    Cart.destroy(session[:cart_id])
    session[:cart_id] = nil

    super
  end
end

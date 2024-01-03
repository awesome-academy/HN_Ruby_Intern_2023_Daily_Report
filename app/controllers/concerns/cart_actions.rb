module CartActions
  extend ActiveSupport::Concern

  private

  def current_cart
    @current_cart ||= Cart.find_by(id: session[:cart_id])
    return if @current_cart

    @current_cart = Cart.create
    session[:cart_id] = @current_cart.id
  end

  def set_cart
    @cart = @current_cart
  end

  def check_cart_empty
    return unless @cart.borrowings.empty?

    flash[:warning] = t "no_books_in_cart"
    redirect_back(fallback_location: root_path)
  end

  def check_user_info
    return if current_account.user_info.present?

    flash[:warning] = t "borrow_info_fill_user_info"
    redirect_to edit_account_path(current_account)
  end
end

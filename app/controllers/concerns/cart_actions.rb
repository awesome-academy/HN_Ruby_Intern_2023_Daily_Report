module CartActions
  extend ActiveSupport::Concern

  private

  def set_cart
    @cart = @current_cart
  end

  def check_cart_empty
    return unless @cart.borrowings.empty?

    flash[:warning] = t "no_books_in_cart"
    redirect_back(fallback_location: root_path)
  end
end

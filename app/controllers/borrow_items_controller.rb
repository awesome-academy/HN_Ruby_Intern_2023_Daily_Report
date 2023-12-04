class BorrowItemsController < ApplicationController
  before_action :require_login
  before_action :set_borrow_item, only: %i(destroy)

  def create
    chosen_book = Book.find_by(id: params[:book_id])

    if @current_cart.books.include?(chosen_book)
      @borrow_item = @current_cart.borrowings.find_by(book_id: chosen_book)
      handle_quantity_change
      return
    else
      @borrow_item = BorrowItem.new(cart: @current_cart, book: chosen_book)
    end

    @borrow_item.save
    flash[:success] = t "book_added_successfully"
    redirect_back(fallback_location: root_path)
  end

  def destroy
    if @borrow_item.destroy
      flash[:success] = t "delete_success"
    else
      flash[:warning] = t "delete_fail"
    end
    redirect_to carts_path
  end

  private

  def set_borrow_item
    @borrow_item = BorrowItem.find_by(id: params[:id])
    return if @borrow_item

    flash[:warning] = t "item_not_found"
    redirect_to root_path
  end

  # Only borrow 1 book
  def handle_quantity_change
    flash[:warning] = t "book_borrow_one" if @borrow_item.quantity == 1
    redirect_back(fallback_location: root_path)
  end
end

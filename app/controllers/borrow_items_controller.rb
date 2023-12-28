class BorrowItemsController < ApplicationController
  include CartActions

  before_action :authenticate_account!
  before_action :set_borrow_item, only: %i(destroy)
  before_action :check_user_info

  def create
    chosen_book = Book.find_by(id: params[:book_id])

    if chosen_book.amount > chosen_book.borrowed_count
      handle_cart_item chosen_book
    else
      flash.now[:warning] = t "book_out_of_stock"
      redirect_back(fallback_location: root_path)
    end
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

    flash.now[:warning] = t "item_not_found"
    redirect_to root_path
  end

  def handle_cart_item chosen_book
    if @current_cart.books.include?(chosen_book)
      @borrow_item = @current_cart.borrowings.find_by(book_id: chosen_book)
      flash.now[:warning] = t "book_borrow_one" if @borrow_item.quantity == 1
    else
      @borrow_item = BorrowItem.new(cart: @current_cart, book: chosen_book)
      @borrow_item.save
      flash.now[:success] = t "book_added_successfully"
    end

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end
end

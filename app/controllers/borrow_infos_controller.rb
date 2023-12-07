class BorrowInfosController < ApplicationController
  include CartActions

  before_action :require_login, only: %i(new)
  before_action :set_cart, only: %i(new)
  before_action :check_cart_empty, only: %i(new)

  # handle later
  def index
    @borrow_infos = BorrowInfo.all
  end

  def show
    @borrow_info = BorrowInfo.find_by(id: params[:id])
    return if @borrow_info

    flash[:warning] = t "borrow_info_not_found"
    redirect_to root_path
  end

  def new
    @borrow_info = BorrowInfo.new
  end

  def create
    @borrow_info = BorrowInfo.new borrow_info_params
    @borrow_info.account_id = current_account.id if logged_in?

    if @borrow_info.save
      check_user_info_and_save
    else
      render :new, status: :bad_request
    end
  end

  private

  def borrow_info_params
    params
      .require(:borrow_info)
      .permit :start_at, :end_at, :status, :remain_turns, :account_id
  end

  def check_user_info_and_save
    if current_account.user_info.present?
      move_item_from_cart

      flash[:success] = t "borrow_info_success"
      redirect_to @borrow_info
    else
      flash[:warning] = t "borrow_info_fill_user_info"
      redirect_to edit_account_path(current_account)
    end
  end

  def move_item_from_cart
    @current_cart.borrowings.include_books.each do |borrow_item|
      @borrow_info.borrowings << borrow_item
      borrow_item.update(cart_id: nil)
    end

    Cart.destroy(session[:cart_id])
    session[:cart_id] = nil
  end
end

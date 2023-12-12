class BorrowInfosController < ApplicationController
  include CartActions

  before_action :authenticate_account!
  before_action :set_cart, only: %i(new)
  before_action :check_cart_empty, only: %i(new)
  before_action :check_user_info, except: %i(index show)
  before_action :set_borrow_info, only: %i(show handle_status_action)

  def index
    status = translate_status_to_english(params[:status_option]) || "pending"
    @pagy, @borrow_infos_sort = pagy(
      BorrowInfo.for_account(current_account).has_status(status).desc_order,
      items: Settings.digit_5
    )
  end

  def show; end

  def new
    @borrow_info = BorrowInfo.new
  end

  def create
    @borrow_info = BorrowInfo.new borrow_info_params
    @borrow_info.account_id = current_account.id if account_signed_in?

    if @borrow_info.save
      move_item_from_cart
      flash[:success] = t "borrow_info_success"
      redirect_to @borrow_info
    else
      render :new, status: :bad_request
    end
  end

  def handle_status_action
    status = params[:status] if params[:status].present?

    case status
    when "pending"
      cancel_borrow_request
    when "approved"
      update_return_date
    else
      flash[:danger] = t "unknown_status_request"
    end
  end

  private

  def set_borrow_info
    @borrow_info = BorrowInfo.find_by(id: params[:id])
    return if @borrow_info

    flash[:warning] = t "borrow_info_not_found"
    redirect_to root_path
  end

  def borrow_info_params
    params
      .require(:borrow_info)
      .permit :start_at, :end_at, :status, :turns, :account_id, :renewal_at
  end

  def move_item_from_cart
    @current_cart.borrowings.include_books.each do |borrow_item|
      @borrow_info.borrowings << borrow_item
      borrow_item.update(cart_id: nil)
    end

    Cart.destroy(session[:cart_id])
    session[:cart_id] = nil
  end

  def cancel_borrow_request
    if @borrow_info.update_attribute(:status, "canceled")
      flash[:success] = t "cancel_request_successfully"
      redirect_to @borrow_info
    else
      flash[:danger] = t "cancel_request_failed"
      redirect_to borrow_infos_path
    end
  end

  def update_return_date
    if @borrow_info.update borrow_info_params.except(:start_at, :end_at)
      @borrow_info.update_attribute(:status, "pending")
      @borrow_info.update_attribute(:turns, @borrow_info.turns + 1)
      @borrow_info.update_attribute(:end_at, borrow_info_params[:renewal_at])
      flash[:success] = t "renew_request_successfully"
      redirect_to @borrow_info
    else
      render :show, status: :bad_request
    end
  end

  def translate_status_to_english status # rubocop:disable Metrics/PerceivedComplexity
    case status&.downcase
    when t("pending")&.downcase
      "pending"
    when t("approved")&.downcase
      "approved"
    when t("rejected")&.downcase
      "rejected"
    when t("canceled")&.downcase
      "canceled"
    when t("returned")&.downcase
      "returned"
    else
      status
    end
  end
end

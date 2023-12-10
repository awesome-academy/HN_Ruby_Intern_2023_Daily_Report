class BorrowInfosController < ApplicationController
  include CartActions

  before_action :require_login
  before_action :set_cart, only: %i(new)
  before_action :check_cart_empty, only: %i(new)
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
    @borrow_info.account_id = current_account.id if logged_in?

    if current_account.user_info.present?
      save_borrow_info
    else
      flash[:warning] = t "borrow_info_fill_user_info"
      redirect_to edit_account_path(current_account)
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
      .permit :start_at, :end_at, :status, :remain_turns, :account_id,
              :renewal_at
  end

  def save_borrow_info
    if @borrow_info.save
      move_item_from_cart
      flash[:success] = t "borrow_info_success"
      redirect_to @borrow_info
    else
      render :new, status: :bad_request
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

  def cancel_borrow_request
    @borrow_info.update_attribute(:status, "rejected")
    @borrow_response = @borrow_info.build_response(content: t("self_cancel"))

    if @borrow_response.save
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
      @borrow_info.update_attribute(:remain_turns,
                                    @borrow_info.remain_turns - 1)
      @borrow_info.update_attribute(:end_at, borrow_info_params[:renewal_at])
      flash[:success] = t "renew_request_successfully"
      redirect_to @borrow_info
    else
      render :show, status: :bad_request
    end
  end

  def translate_status_to_english status
    case status&.downcase
    when t("pending")&.downcase
      "pending"
    when t("approved")&.downcase
      "approved"
    when t("rejected")&.downcase
      "rejected"
    when t("returned")&.downcase
      "returned"
    else
      status
    end
  end
end

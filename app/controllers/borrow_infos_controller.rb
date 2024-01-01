class BorrowInfosController < ApplicationController
  include CartActions

  before_action :authenticate_account!
  before_action :set_cart, only: %i(new)
  before_action :check_cart_empty, only: %i(new)
  before_action :check_user_info, except: %i(index show)
  before_action :set_borrow_info, except: %i(index new create)
  before_action :correct_account, except: %i(index)

  def index
    @q = BorrowInfo.ransack(params[:q])
    @pagy, @borrow_infos_sort = pagy(
      @q.result.for_account(current_account).desc_order,
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

  def download
    send_pdf(disposition: "attachment")
  end

  def preview
    send_pdf(disposition: "inline")
  end

  private

  def set_borrow_info
    @borrow_info = BorrowInfo.find_by(id: params[:id])
    return if @borrow_info

    flash[:warning] = t "borrow_info_not_found"
    redirect_to borrow_infos_path
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
    if @borrow_info.perform_action :renew, borrow_info_params[:renewal_at]
      flash[:success] = t "renew_request_successfully"
      redirect_to @borrow_info
    else
      render :show, status: :bad_request
    end
  end

  def correct_account
    return if @borrow_info && @borrow_info.account == current_account

    flash.now[:warning] = t "borrow_info_not_found"
    redirect_to borrow_infos_path
  end

  def send_pdf disposition:
    pdf = BorrowInfoPdf.new(@borrow_info)
    send_data(
      pdf.render,
      filename: t("pdf_filename") + "#{@borrow_info.id}.pdf",
      type: "application/pdf",
      disposition:
    )
  end
end

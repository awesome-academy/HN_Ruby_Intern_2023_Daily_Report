class Admin::BorrowsController < Admin::BaseController
  before_action :get_borrow, only: %i(show return reject approve remind)
  before_action :get_group, only: :index

  def index
    items = case @group
            when :pending then BorrowInfo.pending
            when :history then BorrowInfo.history
            else BorrowInfo.approved
            end

    respond_to_list items
  end

  def show
    @pagy, @books = pagy @borrow.books.remain_least.with_attached_image
    render "admin/shared/tab_books"
  end

  def return
    respond_to_change_status @borrow.approved?, :returned, :approved
  end

  def reject
    if params[:reject_reason].blank?
      flash[:warning] = t "admin.notif.require_reject_reason"
      application_notify
    else
      reason = @borrow.create_response(content: params[:reject_reason])
      respond_to_change_status(
        @borrow.pending? && reason,
        :rejected,
        :pending
      )
    end
  end

  def remind
    BorrowMailer.with(borrow: @borrow).remind.deliver_later
    @borrow.account&.notification_for_me :urgent,
                                         "notifications.borrow_remind",
                                         link: borrow_info_path(@borrow)
    flash[:success] = t "admin.notif.send_remind_email_success"
    application_notify
  end

  def approve
    respond_to_change_status @borrow.pending?, :approved, :pending
  end

  private

  def get_borrow
    @borrow = BorrowInfo.find_by id: params[:id]
    return if @borrow

    text = t(
      "admin.notif.item_not_found",
      name: t("borrows._name")
    )
    flash[:error] = text
    redirect_to admin_borrows_path
  end

  def update_books_borrowed_count status
    pass = %i(approved returned).include?(status) &&
           @borrow.add_to_book_borrowed_count(status == :approved ? 1 : -1)
    unless pass
      flash[:error] = t(
        "admin.notif.update_borrow_status_fail",
        status: t("borrows.#{status}")
      )
    end
    pass
  end

  def respond_to_change_status condition, status, group
    unless condition || update_books_borrowed_count(status)
      redirect_back_or_to admin_borrows_path(group:)
    end

    @borrow.update_attribute :status, status

    text = t(
      "admin.notif.update_borrow_status_success_html",
      status: t("borrows.#{status}")
    )
    flash[:success] = text
    redirect_back_or_to admin_borrows_path(group:)
  end

  def respond_to_list borrows
    transform_params
    borrows = borrows.includes_user

    q = params[:q]
    borrows = borrows.merge(BorrowInfo.bquery(q)) if q

    s = params[:sort]
    borrows = s ? borrows.sort_on(s, params[:desc]) : borrows.newest

    @pagy, @borrows = pagy borrows
  end

  def transform_params
    permit_sorts = {
      user: "accounts.username",
      start: "borrow_infos.start_at",
      due: "borrow_infos.end_at",
      updated: "borrow_infos.updated_at",
      status: "borrow_infos.status",
      turns: "borrow_infos.turns"
    }
    s = params[:sort]&.downcase&.to_sym
    params[:sort] = permit_sorts[s]
  end

  def get_group
    @group = params[:group]&.to_sym
    @group = :approved unless %i(pending history).include? @group
  end
end

class Admin::BorrowsController < Admin::BaseController
  before_action :get_borrow, only: %i(show return reject approve remind)
  before_action :get_group, only: :index

  def index
    items = case @group
            when :pending then BorrowInfo.waiting
            when :history then BorrowInfo.history
            else BorrowInfo.borrowing
            end

    respond_to_list items
  end

  def show
    @pagy, @books = pagy @borrow.books.remain_least.with_attached_image
    render "admin/shared/tab_books"
  end

  def return
    respond_to_change_status :return
  end

  def reject
    if params[:reject_reason].blank? ||
       !@borrow.create_response(content: params[:reject_reason])
      flash[:warning] = t "admin.notif.require_reject_reason"
      application_notify
    else
      respond_to_change_status :reject
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
    respond_to_change_status :approve
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

  def respond_to_change_status action
    group = action == :return ? :borrowing : :pending
    result = @borrow.perform_action(action) ? :success : :error

    notify_result_to_user(action) if result == :success

    flash[result] = t "admin.notif.#{action}_borrow_#{result}"
    redirect_back_or_to admin_borrows_path(group:)
  end

  def notify_result_to_user action
    link = borrow_info_path @borrow
    account = @borrow.account
    if %i(approve reject).include? action
      BorrowMailer.with(borrow: @borrow).notify_result.deliver_later
      account&.notification_for_me :info,
                                   "notifications.borrow_#{@borrow.status}",
                                   link:
    elsif @borrow.overdue?
      account&.notification_for_me :notice,
                                   "notifications.borrow_returned_overdue",
                                   link:
    end
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
      account: "accounts.username",
      user: "user_infos.name",
      start: "borrow_infos.start_at",
      due: "borrow_infos.end_at",
      updated: "borrow_infos.updated_at",
      type: "borrow_infos.status",
      turns: "borrow_infos.turns"
    }
    s = params[:sort]&.downcase&.to_sym
    params[:sort] = permit_sorts[s]
  end

  def get_group
    @group = params[:group]&.to_sym
    @group = :borrowing unless %i(pending history).include? @group
  end
end

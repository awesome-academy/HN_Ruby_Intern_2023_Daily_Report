class Admin::BorrowsController < Admin::BaseController
  before_action :get_borrow, only: %i(show return reject approve)
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
    if @borrow.approved? && @borrow.add_to_book_borrowed_count(-1)
      respond_to_change_status :returned
    else
      redirect_back_or_to admin_borrows_path
    end
  end

  def reject
    if @borrow.pending? && @borrow.create_response(content: reject_params)
      respond_to_change_status :rejected
    else
      redirect_back_or_to admin_borrows_path
    end
  end

  def approve
    if @borrow.pending? && @borrow.add_to_book_borrowed_count(1)
      respond_to_change_status :approved
    else
      redirect_back_or_to admin_borrows_path
    end
  end

  private

  def get_borrow
    @borrow = BorrowInfo.find_by id: params[:id]
    return if @borrow

    flash[:danger] = {
      content: t("admin.notif.item_not_found", name: t("borrows._name"))
    }
    redirect_to admin_borrows_path
  end

  def respond_to_change_status to
    @borrow.update_attribute :status, to
    flash[:success] = {
      content: t("admin.notif.update_borrow_status_success",
                 status: t("borrows.#{to}"))
    }
    respond_to do |format|
      format.turbo_stream{render :change_status}
      format.html{redirect_to admin_borrows_path}
    end
  end

  def respond_to_list borrows
    transform_params
    borrows = borrows.includes_user

    q = params[:q]
    borrows = borrows.merge(BorrowInfo.bquery(q)) if q

    s = params[:sort]
    borrows = s ? borrows.sort_on(s, params[:desc]) : borrows.due_first

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

  def reject_params
    params.require(:reject_reason)
  end
end

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

  def show; end

  def return; end

  def reject; end

  def approve; end

  private

  def get_borrow
    @borrow = BorrowInfo.find_by id: params[:id]
    return if @borrow&.is_activated

    flash[:danger] = {
      content: t("admin.notif.item_not_found", name: t("borrows._name"))
    }
    redirect_to admin_borrows_path
  end

  def respond_to_list borrows
    transform_params
    borrows = borrows.includes_user

    q = params[:q]
    borrows = borrows.merge(BorrowInfo.bquery(q)) if q

    s = params[:sort]
    borrows = s ? borrows.sort_on(s, params[:desc]) : borrows.due_first

    @pagy, @borrows = pagy borrows, items: params[:item]
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
    @group = params[:group].to_sym
    @group = :approved unless %i(pending history).include? @group
  end
end

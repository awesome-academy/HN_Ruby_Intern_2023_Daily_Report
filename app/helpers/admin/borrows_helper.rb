module Admin::BorrowsHelper
  def populate_borrow borrow
    {
      user: borrow.account,
      full_name: borrow.account.user_info&.name,
      start: localize_date(borrow.start_at),
      due: localize_date(borrow.end_at),
      turns: borrow.turns,
      updated_at: localize_date(borrow.updated_at),
      status: t("borrows.#{borrow.status}"),
      borrow_path: admin_borrow_path(borrow),
      id: dom_id(borrow, :borrow)
    }
  end
end

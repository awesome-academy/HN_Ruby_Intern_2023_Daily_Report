class ReportMailer < ApplicationMailer
  default to: ->{Account.only_admin.pluck(:email)}

  def week_report
    pivot = Time.zone.yesterday
    @from = l pivot.beginning_of_week, format: :short
    @to = l pivot.end_of_week, format: :short
    @data = populate_data :week, pivot

    mail subject: t(".subject", from: @from, to: @to)
  end

  private
  def populate_data period, pivot
    borrows = BorrowInfo.recently(period, pivot:)
    returned_borrow = BorrowInfo.returned
                                .recently(period, pivot:,
                                          attribute: :updated_at)
                                .count
    {
      new_users: UserInfo.recently(period, pivot:),
      new_books: Book.recently(period, pivot:),
      new_borrow: borrows.not_canceled.count,
      pending_borrow: BorrowInfo.pending.count,
      approved_borrow: borrows.approved.count,
      rejected_borrow: borrows.rejected.count,
      returned_borrow:
    }
  end
end

# Preview all emails at http://localhost:3000/rails/mailers/borrow_mailer
class BorrowMailerPreview < ActionMailer::Preview
  def notify_result
    BorrowMailer.with(borrow: BorrowInfo.rejected.first).notify_result
  end

  def remind
    BorrowMailer.with(borrow: BorrowInfo.first).remind
  end
end

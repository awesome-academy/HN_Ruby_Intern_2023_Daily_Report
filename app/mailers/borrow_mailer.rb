class BorrowMailer < ApplicationMailer
  before_action :send_mail
  default to: ->{@borrow.account.email}

  def notify_result; end

  def remind; end

  private

  def send_mail
    @borrow = params[:borrow]
    account = @borrow.account
    @user = account.user_info.presence&.name || account.username
    mail
  end
end

# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def notify_inactive
    UserMailer.with(user: Account.where(is_active: false).first).notify_inactive
  end
end

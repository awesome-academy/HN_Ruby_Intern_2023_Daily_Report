class UserMailer < ApplicationMailer
  def notify_inactive
    user = params[:user]
    @name = user.user_info.presence&.name || user.username
    @time = l user.updated_at, format: :long
    @reason = t ".reason"
    mail to: user.email
  end
end

class Admin::NotificationsController < Admin::BaseController
  def index
    notifs = Notification.for_me(@current_account).created_order

    @pagy, @notifications = pagy notifs
  end

  def read_all
    Notification.for_me(@current_account)
                .unchecked.in_batches
                .update_all(checked: true)
  end

  def update
    @notification = Notification.find_by id: params[:id]
    return unless @notification

    @notification.update checked: true

    redirect_to(@notification.link) if @notification.link
  end
end

class NotificationsController < ApplicationController
  def index
    notifications = Notification.for_me(current_account).created_order

    @pagy, @notifications = pagy(notifications, items: Settings.digit_4)
  end

  def read_all
    Notification.unchecked.in_batches.update_all(checked: true)

    redirect_back(fallback_location: root_path)
  end

  def update
    @notification = Notification.find_by id: params[:id]
    return unless @notification

    @notification.update checked: true

    if @notification.link
      redirect_to(@notification.link)
    else
      redirect_back(fallback_location: root_path)
    end
  end
end

module NotificationsHelper
  def get_icon_color notification
    status_icon = {
      info: {icon: "info", color: "primary"},
      notice: {icon: "check", color: "success"},
      urgent: {icon: "exclamation", color: "danger"}
    }
    status_icon[notification.status.to_sym]
  end

  def notification_uncheck_style notification, color
    "fw-bold text-#{color}" if notification.checked == false
  end

  def unchecked_count
    Notification.for_me(current_account).unchecked.count
  end
end

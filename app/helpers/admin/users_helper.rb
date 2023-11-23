module Admin::UsersHelper
  def get_info account
    info = account&.user_info
    return unless account&.is_activated && info.present?

    is_active = account.is_active

    button_link = admin_user_inactive_path account
    button_link = admin_user_active_path account unless is_active
    button_color = is_active ? :success : :danger
    time_ago = time_ago_in_words info.created_at
    {
      email: account.email,
      full_name: info.name,
      phone: info.phone,
      dob: info.dob,
      join_about: format_time_ago(time_ago),
      button_color:,
      button_link:,
      is_active:,
      user_path: admin_user_path(account)
    }
  end
end

module Admin::UsersHelper
  def get_info account
    info = account.user_info
    {
      # Contact
      email: account.email,
      phone: info&.phone,
      address: info&.address,
      # Account
      username: account.username,
      avatar: get_image(account),
      join_from: localize_date(info&.created_at, :long),
      join_about: time_ago(info&.created_at),
      # Profile
      full_name: info&.name,
      dob: localize_date(info&.dob, :long),
      gender: t("users.#{info&.gender}"), # info.gender return string
      citizen_id: info&.citizen_id,
      updated_at: localize_date(info&.updated_at, :long),
      # Other
      user_path: admin_user_path(account)
    }
  end

  def get_status_color account
    account&.is_activated && account&.is_active ? :success : :danger
  end

  def get_status_button account
    return unless account&.is_activated

    is_active = account.is_active

    status_text = is_active ? t("users.active") : t("users.inactive")
    do_text = is_active ? t(".do_inactive") : t(".do_active")

    confirm_text = t(".do_active_confirm")
    confirm_text = t(".do_inactive_confirm") if is_active

    color = is_active ? :success : :danger

    link = inactive_admin_user_path account
    link = active_admin_user_path account unless is_active
    id = dom_id account, :status

    {status_text:, do_text:, confirm_text:, link:, color:, id:}
  end

  def get_user_tab_headers user
    [
      {
        icon: :note,
        title: t("users.profile"),
        id: :user_profile,
        link: admin_user_path(user)
      },
      {
        icon: :heart,
        title: t("users.favorite"),
        id: :user_favorite,
        link: "#"
      }
    ]
  end
end

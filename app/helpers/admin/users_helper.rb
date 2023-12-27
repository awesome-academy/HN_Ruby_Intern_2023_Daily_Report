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
      # Other
      user_path: admin_user_path(account),
      updated_at: localize_date(account.updated_at)
    }
  end

  def get_status_color account
    account&.is_activated && account&.is_active ? :success : :danger
  end

  def get_status_button account
    return unless account&.is_activated

    if account.is_active?
      {
        link: inactive_admin_user_path(account),
        color: :success,
        confirm_text: t(".do_inactive_confirm"),
        status_text: t("users.active"),
        do_text: t(".do_inactive"),
        data: {
          bs_toggle: :modal,
          bs_target: "#inactive_reason_modal"
        }
      }
    else
      {
        link: active_admin_user_path(account),
        color: :danger,
        confirm_text: t(".do_active_confirm"),
        status_text: t("users.inactive"),
        do_text: t(".do_active")
      }
    end
  end

  def get_user_tab_headers user
    [
      {
        icon: :note,
        title: t("users.profile"),
        id: :user_profile,
        link: admin_user_path(user)
      }
    ]
  end
end

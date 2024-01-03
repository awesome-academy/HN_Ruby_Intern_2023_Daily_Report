class Admin::SessionsController < Devise::SessionsController
  layout "admin/layouts/sessions"
  skip_before_action :current_cart

  def after_sign_in_path_for account
    return admin_root_path if account.is_admin?

    sign_out
    flash[:alert] = t "admin.notif.require_admin"
    root_path
  end

  def after_sign_out_path_for _account
    new_admin_account_session_path
  end

  def create
    super do |resource|
      sign_out unless resource.is_admin?
    end
  end
end

class Admin::PasswordsController < Devise::PasswordsController
  layout "admin/layouts/sessions"
  skip_before_action :current_cart

  def after_resetting_password_path_for _account
    admin_root_path
  end
end

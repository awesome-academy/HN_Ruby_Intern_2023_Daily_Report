class Admin::SessionsController < SessionsController
  layout "admin/layouts/sessions"

  def on_login_success
    redirect_to admin_root_path
  end

  def on_login_fail_inactive
    flash.now[:danger] = t "admin.notif.account_not_activated_or_lock"
    render :new, status: :bad_request
  end

  def on_login_fail
    flash.now[:danger] = t "admin.notif.invalid_email_password"
    render :new, status: :bad_request
  end

  def on_logout
    redirect_back_or admin_login_path
  end
end

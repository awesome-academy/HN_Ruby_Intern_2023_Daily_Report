class Admin::SessionsController < SessionsController
  layout "admin/layouts/sessions"

  def on_login_success
    redirect_to admin_root_path
  end

  def on_login_fail
    flash.now[:danger] = t "sessions.login_fail"
    render :new, status: :bad_request
  end

  def on_logout
    redirect_back_or admin_login_path
  end
end

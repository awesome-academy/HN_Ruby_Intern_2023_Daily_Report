class Admin::SessionsController < SessionsController
  skip_before_action :current_cart
  layout "admin/layouts/sessions"

  def check_before_save_session account
    account.is_admin
  end

  def on_login_success
    flash[:success] = t "admin.notif.login_success"
    redirect_back_or admin_root_path
  end

  def on_login_fail_inactive
    flash.now[:error] = t "admin.notif.account_not_activated_or_lock"
    notify
  end

  def on_login_fail
    flash.now[:error] = t "admin.notif.invalid_email_password"
    notify
  end

  def on_logout
    redirect_to admin_login_path
  end

  private

  def notify
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "application-notify",
          partial: "admin/shared/notify"
        )
      end
      format.html{render :new, status: :unprocessable_entity}
    end
  end
end

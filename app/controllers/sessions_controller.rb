class SessionsController < ApplicationController
  def create
    account = Account.find_by email: params.dig(:session, :email)&.downcase
    unless account&.is_activated && account&.is_active
      return on_login_fail_inactive
    end

    return on_login_fail unless account&.authenticate(
      params.dig(:session, :password)
    )

    reset_session
    store_to_session account

    if params.dig(:session, :remember_me) == "1"
      remember account
    else
      forget account
    end

    on_login_success
  end

  def destroy
    remove_from_session if logged_in?
    on_logout
  end

  protected

  def on_login_success
    redirect_back_or books_path
  end

  def on_login_fail_inactive
    flash.now[:danger] = t "account_not_activated_or_lock"
    render :new, status: :bad_request
  end

  def on_login_fail
    flash.now[:danger] = t "invalid_email_password"
    render :new, status: :bad_request
  end

  def on_logout
    redirect_to root_path
  end
end

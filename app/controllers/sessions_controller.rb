class SessionsController < ApplicationController
  def create
    account = Account.find_by email: params.dig(:session, :email)&.downcase

    return unless validate account

    reset_session
    store_to_session account

    set_remember_for account

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
    render :new, status: :unprocessable_entity
  end

  def on_login_fail
    flash.now[:danger] = t "invalid_email_password"
    render :new, status: :unprocessable_entity
  end

  def check_before_save_session _account
    true
  end

  def on_logout
    redirect_to root_path
  end

  private

  def validate account
    unless account&.is_activated && account&.is_active
      on_login_fail_inactive
      return false
    end

    unless account&.authenticate(params.dig(:session, :password)) &&
           check_before_save_session(account)
      on_login_fail
      return false
    end
    true
  end

  def set_remember_for account
    if params.dig(:session, :remember_me) == "1"
      remember account
    else
      forget account
    end
  end
end

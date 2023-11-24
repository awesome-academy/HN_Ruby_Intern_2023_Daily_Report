class SessionsController < ApplicationController
  def create
    account = Account.find_by email: params.dig(:session, :email)&.downcase
    if account&.authenticate params.dig(:session, :password)
      reset_session
      store_to_session account
      if params.dig(:session, :remember_me) == "1"
        remember account
      else
        forget account
      end
      on_login_success
    else
      on_login_fail
    end
  end

  def destroy
    remove_from_session if logged_in?
    on_logout
  end

  protected

  def on_login_success
    redirect_back_or root_path
  end

  def on_login_fail
    flash.now[:danger] = t "invalid_email_password"
    render :new, status: :bad_request
  end

  def on_logout
    redirect_to root_path
  end
end

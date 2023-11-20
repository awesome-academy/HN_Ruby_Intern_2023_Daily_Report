class SessionsController < ApplicationController
  def create
    account = Account.find_by email: params.dig(:session, :email).downcase
    if account&.authenticate params.dig(:session, :password)
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

  def on_login_success; end

  def on_login_fail; end

  def on_logout; end
end

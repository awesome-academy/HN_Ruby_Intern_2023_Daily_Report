module SessionsHelper
  def store_to_session account
    session[:account_id] = account.id
  end

  # Logs out the current user.
  def remove_from_session
    forget @current_account
    session.delete :account_id
    @current_account = nil
  end

  # Returns the current logged-in user (if any).
  def current_account
    if account_id = session[:account_id]
      @current_account ||= Account.find_by id: account_id
    elsif account_id = cookies.encrypted[:account_id]
      account = Account.find_by id: account_id
      if account&.token_match? :remember, cookies[:remember_token]
        store_to_session account
        @current_account = account
      end
    end
    @current_account
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    current_account.present?
  end

  # Remembers a user in a persistent session.
  def remember account
    account.remember
    cookies.permanent.encrypted[:account_id] = account.id
    cookies.permanent[:remember_token] = account.remember_token
  end

  # Forgets a persistent session.
  def forget account
    account.forget
    cookies.delete :account_id
    cookies.delete :remember_token
  end

  # Redirects to stored location (or to the default).
  def redirect_back_or default
    redirect_to(session[:forwarding_url] || default)
    session.delete :forwarding_url
  end

  # Stores the URL trying to be accessed.
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  # Login is required to use functions
  def require_login
    return if logged_in?

    flash[:warning] = t("log_in_required")
    redirect_to login_path
  end

  def borrow_item_quantity
    @current_cart.borrowings.sum(&:quantity)
  end
end

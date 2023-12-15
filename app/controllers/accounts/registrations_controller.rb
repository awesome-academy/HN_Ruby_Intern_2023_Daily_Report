class Accounts::RegistrationsController < Devise::RegistrationsController
  protected

  # The path used after sign up.
  def after_sign_up_path_for resource
    flash[:notice] = t "account_create_success"
    edit_account_path(resource)
  end
end

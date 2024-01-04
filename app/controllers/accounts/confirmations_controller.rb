class Accounts::ConfirmationsController < Devise::ConfirmationsController
  def show
    super(&:activate)
  end
end

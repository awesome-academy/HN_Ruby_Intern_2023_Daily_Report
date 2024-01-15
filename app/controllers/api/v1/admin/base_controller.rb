class API::V1::Admin::BaseController < API::ApplicationController
  before_action :require_admin!

  private

  def require_admin!
    return if @current_account.is_admin?

    json_message :no_permission, status: :unauthorized
  end
end

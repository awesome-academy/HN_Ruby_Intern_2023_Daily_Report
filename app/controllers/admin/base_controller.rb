class Admin::BaseController < ApplicationController
  layout "admin/layouts/base"
  before_action :require_admin

  private

  def require_admin
    redirect_to admin_login_path unless current_account&.is_admin?
  end
end

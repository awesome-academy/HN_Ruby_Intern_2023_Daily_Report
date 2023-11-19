class Admin::BaseController < ApplicationController
  layout "admin/layouts/base"
  before_action :require_admin

  private

  def require_admin
    is_admin = true
    redirect_to root_path unless is_admin
  end
end

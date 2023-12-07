class Admin::BaseController < ApplicationController
  layout "admin/layouts/base"
  include Admin::BaseHelper
  before_action :require_admin
  before_action :transform_sort_params, only: :index

  def index; end

  protected

  def respond_to_form_fail obj
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(
          "form-fail",
          obj.errors.full_messages
        )
      end
      format.html{render :edit, status: :unprocessable_entity}
      format.js
    end
  end

  private

  def require_admin
    redirect_to admin_login_path unless current_account&.is_admin?
  end

  def transform_sort_params
    params[:desc] = params[:style]&.downcase == :desc.to_s
  end
end

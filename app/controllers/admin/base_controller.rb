class Admin::BaseController < ApplicationController
  layout "admin/layouts/base"
  include Admin::BaseHelper
  before_action :require_admin
  before_action :transform_sort_params, only: :index
  skip_before_action :current_cart

  def index; end

  protected

  def respond_to_form_fail obj
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.update(
          "form-fail",
          partial: "admin/shared/form_fail",
          locals: {obj:}
        )
      end
      format.html{render :edit, status: :unprocessable_entity}
    end
  end

  def admin_save object, name, success_to: nil
    if object.save
      text = t "admin.notif.create_success", name: t("#{name}s._name")
      flash[:success] = text

      to = public_send("admin_#{name}s_path")
      to = public_send(success_to, object) if success_to
      redirect_to to
    else
      respond_to_form_fail object
    end
  end

  def admin_update object, attributes, name, success_to: nil
    if object.update attributes
      text = t "admin.notif.update_success", name: t("#{name}s._name")
      flash[:success] = text

      to = public_send("admin_#{name}s_path")
      to = public_send(success_to, object) if success_to
      redirect_to to
    else
      respond_to_form_fail object
    end
  end

  def admin_destroy object, name, destroy_method: nil
    if destroy_method.nil? ? object.destroy : destroy_method
      text = t "admin.notif.delete_success", name: t("#{name}s._name")
      flash[:success] = text
    else
      flash[:error] = t "admin.notif.delete_fail", name: t("#{name}s._name")
    end
    redirect_to public_send("admin_#{name}s_path")
  end

  def application_notify
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          "application-notify",
          partial: "admin/shared/notify"
        )
      end
      format.js{render inline: "location.reload();"}
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

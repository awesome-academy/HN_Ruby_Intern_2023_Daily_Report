class API::V1::Admin::BaseController < API::ApplicationController
  before_action :require_admin!

  protected

  def response_for_action action, result, object, name
    if result
      json_response object
    else
      json_errors object, I18n.t("api.#{action}_fail",
                                 name: I18n.t("#{name}s._name"))
    end
  end

  def admin_save object, name
    response_for_action :create, object.save, object, name
  end

  def admin_update object, attributes, name
    result = object.update attributes
    response_for_action :update, result, object, name
  end

  def admin_destroy object, name, destroy_method: nil
    result = destroy_method.nil? ? object.destroy : destroy_method
    response_for_action :delete, result, object, name
  end

  private

  def require_admin!
    return if @current_account.is_admin?

    json_message :no_permission, status: :unauthorized
  end
end

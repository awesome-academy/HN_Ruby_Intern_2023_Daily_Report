class API::V1::BaseController < API::ApplicationController
  protected

  def user_response_for_action action, result, object, name
    if result
      json_response object
    else
      json_errors object, I18n.t("api.#{action}_fail",
                                 name: I18n.t("#{name}s._name"))
    end
  end

  def user_save object, name
    user_response_for_action :create, object.save, object, name
  end

  def user_update object, attributes, name
    result = object.update attributes
    user_response_for_action :update, result, object, name
  end

  def user_destroy object, name, destroy_method: nil
    result = destroy_method.nil? ? object.destroy : destroy_method
    user_response_for_action :delete, result, object, name
  end
end

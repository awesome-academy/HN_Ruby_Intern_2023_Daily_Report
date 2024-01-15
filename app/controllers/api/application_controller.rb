class API::ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found

  before_action :authenticate!
  before_action :set_locale

  def default_url_options
    {locale: I18n.locale}
  end

  protected

  def json_errors object
    render json: {message: object.errors.full_messages},
           status: :unprocessable_entity
  end

  def json_message message, status: :bad_request
    render json: {message: I18n.t(message)}, status:
  end

  def json_response object, status: :ok
    render json: object, status:
  end

  def authenticate!
    authenticate_user_with_token || handle_bad_authentication
  end

  def authenticate_user_with_token
    authenticate_with_http_token do |token|
      @current_account = Account.find_from_token token
    end
  end

  def handle_bad_authentication
    json_message :bad_credentials, status: :unauthorized
  end

  def handle_not_found
    json_message :record_not_found, status: :not_found
  end

  private

  def set_locale
    locale = params[:locale].to_s.strip.to_sym
    I18n.locale = I18n.default_locale
    I18n.locale = locale if I18n.available_locales.include?(locale)
  end
end

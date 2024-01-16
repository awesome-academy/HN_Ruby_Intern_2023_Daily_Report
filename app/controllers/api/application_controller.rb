class API::ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include Pagy::Backend
  include ActiveStorage::SetCurrent # for extract link to attachment

  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found

  before_action :authenticate!
  before_action :set_locale

  def default_url_options
    {locale: I18n.locale}
  end

  attr_reader :current_account

  serialization_scope :current_account

  protected

  def json_errors object, message
    render json: {message:, errors: object.errors.full_messages},
           status: :unprocessable_entity
  end

  def json_message message, status: :bad_request
    render json: {message: I18n.t("api.#{message}")}, status:
  end

  def json_response object, status: :ok, **options
    render json: object, status:, **options
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
    @pagy_locale = params[:locale]
  end
end

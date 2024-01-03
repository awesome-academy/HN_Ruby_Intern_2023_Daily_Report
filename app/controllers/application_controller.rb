class ApplicationController < ActionController::Base
  include Pagy::Backend
  include CartActions

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale
  before_action :current_cart, if: :account_signed_in?

  def default_url_options
    {locale: I18n.locale}
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :sign_up, keys: [:email, :password, :password_confirmation, :username]
    )
  end

  private

  def set_locale
    locale = params[:locale].to_s.strip.to_sym
    I18n.locale = I18n.default_locale
    I18n.locale = locale if I18n.available_locales.include?(locale)
    @pagy_locale = params[:locale]
  end
end

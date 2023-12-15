class ApplicationController < ActionController::Base
  include Pagy::Backend

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale
  before_action :current_cart

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

  def current_cart
    if session[:cart_id]
      cart = Cart.find_by(id: session[:cart_id])
      if cart.present?
        @current_cart = cart
      else
        session[:cart_id] = nil
      end
    end
    return if session[:cart_id].present?

    @current_cart = Cart.create
    session[:cart_id] = @current_cart.id
  end
end

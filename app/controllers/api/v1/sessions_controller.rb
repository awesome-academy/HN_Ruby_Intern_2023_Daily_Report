class API::V1::SessionsController < API::ApplicationController
  skip_before_action :authenticate!, only: :authenticate

  def authenticate
    user = Account.find_for_authentication email: auth_params[:email],
                                           is_activated: true,
                                           is_active: true
    if user&.valid_password? auth_params[:password]
      token = user.renew_api_token
      json_response({id: user.id, token:})
    else
      json_message :authenticate_fail
    end
  end

  def me
    json_response @current_account
  end

  private

  def auth_params
    params.require(:account).permit :email, :password
  end
end

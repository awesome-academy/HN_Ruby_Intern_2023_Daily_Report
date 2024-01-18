class API::V1::RegistrationsController < API::V1::BaseController
  skip_before_action :authenticate!

  def register
    @account = Account.new sign_up_params

    if @account.save
      json_message :register_check_email, status: :ok
    else
      user_response_for_action :create, @account.save, @account, :account
    end
  end

  private

  def sign_up_params
    params.require(:account)
          .permit :email, :password, :password_confirmation, :username
  end
end

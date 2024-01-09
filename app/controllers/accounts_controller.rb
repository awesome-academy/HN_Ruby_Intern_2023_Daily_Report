class AccountsController < ApplicationController
  before_action :authenticate_account!
  before_action :set_account
  before_action :correct_account

  def show
    return if @account&.favorite_authors.blank?

    @authors = @account.favorite_authors

    @pagy, @authors = pagy(
      @authors.with_attached_avatar,
      items: Settings.digit_4
    )
  end

  def edit
    return unless @account.user_info.nil?

    @account.build_user_info
  end

  def update
    if @account.update_with_password(account_params)
      bypass_sign_in @account
      flash[:success] = t "update_success"
      redirect_to @account
    else
      render :edit, status: :bad_request
    end
  end

  private

  def set_account
    @account = Account.find_by id: params[:id]
    return if @account

    flash[:warning] = t "account_not_found"
    redirect_to root_path
  end

  def account_params
    params
      .require(:account)
      .permit :email, :password, :password_confirmation, :current_password,
              :username, :avatar,
              user_info_attributes:
                %i(id name gender address phone citizen_id dob)
  end

  def correct_account
    return if @account == current_account

    flash[:warning] = t "account_not_found"
    redirect_to root_path
  end
end

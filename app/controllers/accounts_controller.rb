class AccountsController < ApplicationController
  before_action :require_login, only: %i(show edit update)
  before_action :set_account, only: %i(show edit update)
  before_action :correct_account, only: %i(show edit update)

  def show; end

  def new
    @account = Account.new
  end

  def create
    @account = Account.new account_params
    if @account.save
      reset_session
      store_to_session @account
      flash[:success] = t "account_create_success"
      redirect_to root_path
    else
      render :new, status: :bad_request
    end
  end

  def edit
    return unless @account.user_info.nil?

    @account.build_user_info
  end

  def update
    if @account.update account_params
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
      .permit :email, :password, :password_confirmation, :username, :avatar,
              user_info_attributes:
                %i(id name gender address phone citizen_id dob)
  end

  def correct_account
    return if @account == @current_account

    flash[:warning] = t "account_not_found"
    redirect_to root_path
  end
end

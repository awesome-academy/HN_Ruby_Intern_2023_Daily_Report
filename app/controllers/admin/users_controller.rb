class Admin::UsersController < Admin::BaseController
  before_action :get_user, only: %i(show active inactive)
  before_action :transform_params, only: :index

  def index
    users = Account.exclude(@current_account).only_activated.includes_info

    q = params[:q]
    users = users.merge(Account.bquery(q)) if q

    s = params[:sort]
    users = s ? users.sort_on(s, params[:desc]) : users.newest

    @pagy, @users = pagy users, items: params[:items]
  end

  def show
    @tab_id = :user_profile
    render :tab_profile
  end

  def active
    respond_to_change_active true
  end

  def inactive
    respond_to_change_active false
  end

  private

  def get_user
    @user = Account.find_by id: params[:id]
    return if @user&.is_activated

    flash[:error] = {
      content: t("admin.notif.item_not_found", name: t("accounts._name"))
    }
    redirect_to admin_users_path
  end

  def respond_to_change_active to
    @user.update_attribute :is_active, to
    text = t(
      "admin.notif.update_user_status_success_html",
      status: t("users.#{to ? :active : :inactive}")
    )
    respond_to do |format|
      format.turbo_stream do
        flash.now[:success] = text
        render :change_status
      end
      format.html do
        flash[:success] = text
        redirect_to admin_users_path
      end
    end
  end

  def transform_params
    permit_sorts = {
      username: "accounts.username",
      name: "user_infos.name",
      phone: "user_infos.phone",
      dob: "user_infos.dob",
      join: "user_infos.created_at"
    }
    s = params[:sort]&.downcase&.to_sym
    params[:sort] = permit_sorts[s]
    params[:desc] = !params[:desc] if %i(join).include? s
  end
end

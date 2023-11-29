class Admin::UsersController < Admin::BaseController
  before_action :get_user, only: %i(show active inactive)
  before_action :transform_params, only: :index

  def index
    users = Account.exclude(@current_account).only_activated.includes_info

    q = params[:q]
    users = users.merge(Account.bquery(q)) if q

    sort = params[:sort]
    users = users.sort_on(sort, params[:desc]) if sort

    @pagy, @users = pagy users, items: params[:items]
  end

  def show; end

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

    flash[:danger] = {content: t("admin.notif.user_not_found")}
    redirect_to admin_users_path
  end

  def respond_to_change_active to
    @user.update_attribute :is_active, to
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          helpers.dom_id(@user, :status),
          partial: "admin/users/status_button",
          locals: {user: @user}
        )
      end
      format.html{redirect_to admin_users_path}
      format.js
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

class Admin::UsersController < Admin::BaseController
  def index
    @pagy, @users = pagy Account.exclude(@current_account).includes_info,
                         items: params[:items] || Settings.items_per_page
  end

  def show; end

  def active; end

  def inactive; end
end

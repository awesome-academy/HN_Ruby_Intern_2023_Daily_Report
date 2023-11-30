class Admin::PublishersController < Admin::BaseController
  before_action :get_publisher, only: %i(show update destroy)
  before_action :transform_params, only: :index

  def index
    publishers = Publisher.all

    q = params[:q]
    publishers = publishers.bquery(q) if q

    s = params[:sort]
    publishers = publishers.sort_on(s, params[:desc]) if s

    @pagy, @publishers = pagy publishers, items: params[:items]
  end

  def show; end

  def new; end

  def edit; end

  def create; end

  def update; end

  def destroy
    if @publisher.destroy
      flash[:success] = t "admin.notif.delete_success"
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.remove(
            helpers.dom_id(@publisher, :publisher)
          )
        end
        format.html
        format.js
      end
    else
      flash[:danger] = t "admin.notif.delete_fail"
    end
  end

  private
  def get_publisher
    @publisher = Publisher.find_by id: params[:id]
    return if @publisher

    flash[:danger] = {
      content: t("admin.notif.item_not_found", name: t("publishers._name"))
    }
    redirect_to admin_publishers_path
  end

  def publisher_params
    params.require(:publisher).permit :name, :address, :about, :email
  end

  def transform_params
    permit_sorts = {
      name: "publishers.name",
      email: "publishers.email"
    }
    s = params[:sort]&.downcase&.to_sym
    params[:sort] = permit_sorts[s]
  end
end

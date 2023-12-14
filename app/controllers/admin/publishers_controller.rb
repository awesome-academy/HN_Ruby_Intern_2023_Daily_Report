class Admin::PublishersController < Admin::BaseController
  before_action :get_publisher, only: %i(show edit update destroy)
  before_action :transform_params, only: :index

  def index
    publishers = Publisher.all

    q = params[:q]
    publishers = publishers.bquery(q) if q

    s = params[:sort]
    publishers = s ? publishers.sort_on(s, params[:desc]) : publishers.newest

    @pagy, @publishers = pagy publishers, items: params[:items]
  end

  def show
    @tab_id = :publisher
    @pagy, @books = pagy @publisher.books.newest.with_attached_image
    render "admin/shared/tab_books"
  end

  def new
    @publisher = Publisher.new
    render :edit
  end

  def edit; end

  def create
    @publisher = Publisher.new publisher_params
    admin_save @publisher, :publisher
  end

  def update
    admin_update @publisher, publisher_params, :publisher
  end

  def destroy
    admin_destroy @publisher, :publisher
  end

  private
  def get_publisher
    @publisher = Publisher.find_by id: params[:id]
    return if @publisher

    flash[:error] = t "admin.notif.item_not_found", name: t("publishers._name")
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

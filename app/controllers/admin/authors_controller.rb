class Admin::AuthorsController < Admin::BaseController
  before_action :get_author, only: %i(show edit update destroy)
  before_action :transform_params, only: :index

  def index
    authors = Author.with_attached_avatar

    q = params[:q]
    authors = authors.bquery(q) if q

    s = params[:sort]
    authors = s ? authors.sort_on(s, params[:desc]) : authors.newest

    @pagy, @authors = pagy authors, items: params[:items]
  end

  def show
    @tab_id = :author_books
    @pagy, @books = pagy @author.books.newest.with_attached_image
    render "admin/shared/tab_books"
  end

  def new
    @author = Author.new
    render :edit
  end

  def edit; end

  def create
    @author = Author.new author_params
    admin_save @author, :author
  end

  def update
    admin_update @author, author_params, :author
  end

  def destroy
    admin_destroy @author, :author
  end

  private

  def get_author
    @author = Author.find_by id: params[:id]
    return if @author

    flash[:error] = t "admin.notif.item_not_found", name: t("authors._name")
    redirect_to admin_authors_path
  end

  def author_params
    params.require(:author).permit :name, :about, :phone,
                                   :email, :avatar
  end

  def transform_params
    permit_sorts = {
      name: "authors.name",
      email: "authors.email",
      phone: "authors.phone"
    }
    s = params[:sort]&.downcase&.to_sym
    params[:sort] = permit_sorts[s]
  end
end

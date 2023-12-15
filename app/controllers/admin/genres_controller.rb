class Admin::GenresController < Admin::BaseController
  before_action :get_genre, only: %i(show edit update destroy)
  before_action :transform_params, only: :index

  def index
    genres = Genre.all

    q = params[:q]
    genres = genres.bquery(q) if q

    s = params[:sort]
    genres = s ? genres.sort_on(s, params[:desc]) : genres.newest

    @pagy, @genres = pagy genres
  end

  def show
    @tab_id = :genre_books
    @pagy, @books = pagy @genre.books.newest.with_attached_image
    render "admin/shared/tab_books"
  end

  def new
    @genre = Genre.new
    render :edit
  end

  def edit; end

  def create
    @genre = Genre.new genre_params
    admin_save @genre, :genre
  end

  def update
    admin_update @genre, genre_params, :genre
  end

  def destroy
    admin_destroy @genre, :genre
  end

  private
  def get_genre
    @genre = Genre.find_by id: params[:id]
    return if @genre

    flash[:error] = t "admin.notif.item_not_found", name: t("genres._name")
    redirect_to admin_genres_path
  end

  def genre_params
    params.require(:genre).permit :name, :description
  end

  def transform_params
    permit_sorts = {
      name: "genres.name"
    }
    s = params[:sort]&.downcase&.to_sym
    params[:sort] = permit_sorts[s]
  end
end

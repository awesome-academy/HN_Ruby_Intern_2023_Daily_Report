class Admin::GenresController < Admin::BaseController
  before_action :get_genre, only: %i(show update destroy)
  before_action :transform_params, only: :index

  def index
    genres = Genre.all

    q = params[:q]
    genres = genres.bquery(q) if q

    s = params[:sort]
    genres = genres.sort_on(s, params[:desc]) if s

    @pagy, @genres = pagy genres, items: params[:items]
  end

  def show; end

  def new; end

  def edit; end

  def create; end

  def update; end

  def destroy
    if @genre.destroy
      flash[:success] = t "admin.notif.delete_success"
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.remove(
            helpers.dom_id(@genre, :genre)
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
  def get_genre
    @genre = Genre.find_by id: params[:id]
    return if @genre

    flash[:danger] = {
      content: t("admin.notif.item_not_found", name: t("genres._name"))
    }
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

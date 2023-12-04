class Admin::AuthorsController < Admin::BaseController
  before_action :get_author, only: %i(show update destroy)
  before_action :transform_params, only: :index

  def index
    authors = Author.with_attached_avatar

    q = params[:q]
    authors = authors.bquery(q) if q

    s = params[:sort]
    authors = authors.sort_on(s, params[:desc]) if s

    @pagy, @authors = pagy authors, items: params[:items]
  end

  def show; end

  def new; end

  def edit; end

  def create; end

  def update; end

  def destroy
    if @author.destroy
      flash[:success] = t "admin.notif.delete_success"
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.remove(
            helpers.dom_id(@author, :author)
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

  def get_author
    @author = Author.find_by id: params[:id]
    return if @author

    flash[:danger] = {
      content: t("admin.notif.item_not_found", name: t("authors._name"))
    }
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

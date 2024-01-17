module Admin::BooksConcern
  extend ActiveSupport::Concern

  included do
    before_action :transform_params, only: :index
    before_action :populate_books, only: :index
  end

  def index; end

  private

  def book_params
    params.require(:book).permit :title, :description, :amount,
                                 :isbn, :publish_date, :image
  end

  def relation_params
    params.require(:book).permit :publisher, authors: [], genres: []
  end

  def transform_params
    permit_sorts = {
      publisher: "publishers.name",
      title: "books.title",
      publish_date: "books.publish_date",
      remain: "books.amount - books.borrowed_count",
      author: "authors.name",
      genre: "genres.name"
    }
    s = params[:sort]&.downcase&.to_sym
    params[:sort] = permit_sorts[s]
  end

  def populate_books
    books = Book.includes_info.available

    q = params[:q]
    books = books.merge(Book.bquery(q)) if q

    s = params[:sort]
    books = s ? books.sort_on(s, params[:desc]) : books.newest

    @pagy, @books = pagy books
  end
end

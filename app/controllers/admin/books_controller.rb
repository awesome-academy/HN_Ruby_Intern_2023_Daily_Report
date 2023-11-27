class Admin::BooksController < Admin::BaseController
  before_action :get_book,
                only: %i(show edit update destroy amend_edit amend)
  before_action :transform_params, only: :index

  def index
    books = Book.includes_info.available

    q = params[:q]
    books = books.merge(Book.bquery(q)) if q

    s = params[:sort]
    books = s ? books.sort_on(s, params[:desc]) : books.newest

    @pagy, @books = pagy books, items: params[:items]
  end

  def show
    @tab_id = :book_detail
    render :tab_detail
  end

  def new
    @book = Book.new
    render :edit
  end

  def edit; end

  def create
    @book = Book.new book_params
    if @book.save
      redirect_to amend_admin_book_path(@book)
    else
      respond_to_form_fail @book
    end
  end

  def update
    return redirect_to amend_admin_book_path(@book) if params.key? :skip

    if @book.update book_params
      flash[:success] = t "admin.notif.update_success"
      redirect_to amend_admin_book_path(@book)
    else
      respond_to_form_fail @book
    end
  end

  def amend_edit; end

  def amend
    @book.transaction do
      if publisher_id = params.dig(:book, :publisher)
        @book.update publisher_id:
      end

      if author_ids = params.dig(:book, :authors)
        @book.update_relation_with_ids(:author, author_ids)
      end

      if genre_ids = params.dig(:book, :genres)
        @book.update_relation_with_ids(:genre, genre_ids)
      end
    end

    if @book.errors.any?
      respond_to_form_fail @book
    else
      flash[:success] = t "admin.notif.update_success"
      redirect_to [:admin, @book]
    end
  end

  def destroy
    if @book.update is_active: false
      flash[:success] = t "admin.notif.delete_success"
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.remove(
            helpers.dom_id(@book, :book)
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
  def get_book
    @book = Book.find_by id: params[:id]
    return if @book

    flash[:danger] = {
      content: t("admin.notif.item_not_found", name: t("books._name"))
    }
    redirect_to admin_books_path
  end

  def book_params
    params.require(:book).permit :title, :description, :remain,
                                 :isbn, :publish_date, :image
  end

  def relation_params
    params.require(:book).permit :publisher, :authors, :genres
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
end

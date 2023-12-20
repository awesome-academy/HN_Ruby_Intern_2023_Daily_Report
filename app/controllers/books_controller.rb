class BooksController < ApplicationController
  def index
    @q = Book.ransack(params[:q])
    filtered_books = @q.result(distinct: true)
                       .with_attached_image.include_authors.newest_book

    if params[:letter].present?
      filtered_books = filtered_books.by_first_letter(params[:letter])
    end

    @pagy, @books = pagy(filtered_books, items: Settings.digit_10)
  end

  def show
    @book = Book.find_by id: params[:id]
    return if @book

    flash[:warning] = t "book_not_found"
    redirect_to books_path
  end
end

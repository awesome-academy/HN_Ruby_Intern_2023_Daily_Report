class BooksController < ApplicationController
  def index
    @pagy, @books = pagy(
      Book.with_attached_image.include_authors.sorted_by_title,
      items: Settings.digit_10
    )
  end

  def show
    @book = Book.find_by id: params[:id]
    return if @book

    flash[:warning] = t "book_not_found"
    redirect_to books_path
  end
end

class BooksController < ApplicationController
  before_action :set_book, only: %i(show)

  def index
    @q = Book.ransack(params[:q])
    filtered_books = @q.result(distinct: true)
                       .with_image_and_authors.newest_book.available

    if params[:letter].present?
      filtered_books = filtered_books.by_first_letter(params[:letter])
    end

    @pagy, @books = pagy(filtered_books, items: Settings.digit_10)
  end

  def show
    comments = @book.comments
                    .newest_comments.include_accounts_with_avatar
                    .with_rich_text_content_and_embeds
    @pagy, @comments = pagy(comments, items: Settings.digit_4)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  private

  def set_book
    @book = Book.find_by(id: params[:id], is_active: true)
    return if @book

    flash.now[:warning] = t "book_not_found"
    redirect_to books_path
  end
end

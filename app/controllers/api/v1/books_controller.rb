class API::V1::BooksController < API::V1::BaseController
  before_action :set_book, only: %i(show)

  def index
    @q = Book.ransack(params[:q])
    filtered_books = @q.result(distinct: true)
                       .includes_info.newest_book.available

    if params[:letter].present?
      filtered_books = filtered_books.by_first_letter(params[:letter])
    end

    @pagy, @books = pagy(filtered_books, items: Settings.digit_10)

    json_response @books
  end

  def show
    @book = Book.find_by(id: params[:id], is_active: true)

    json_response @book
  end

  private

  def set_book
    @book = Book.find_by(id: params[:id], is_active: true)
    return if @book

    handle_not_found
  end
end

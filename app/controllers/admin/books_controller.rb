class Admin::BooksController < Admin::BaseController
  before_action :get_book, only: %i(show update destroy)

  def index
    @pagy, @books = pagy Book.includes_info.available,
                         items: params[:items]
  end

  def show; end

  def new; end

  def edit; end

  def create; end

  def update; end

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

    flash[:danger] = {content: t("admin.notif.book_not_found")}
    redirect_to admin_books_path
  end

  def book_params
    params.require(:book).permit :title, :description, :amount,
                                 :isbn, :publish_date, :image
  end
end

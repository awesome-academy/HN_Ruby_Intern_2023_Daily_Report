class Admin::HomeController < Admin::BaseController
  def index
    @period = params[:period]&.to_sym || :month
  end

  def export_library
    respond_to do |format|
      format.xlsx do
        @books = Book.includes_info
        @publishers = Publisher.all
        @authors = Author.with_attached_avatar
        @genres = Genre.all
        render xlsx: "books", template: "admin/home/export_library"
      end
    end
  end
end

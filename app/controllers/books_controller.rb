class BooksController < ApplicationController
  def index
    @pagy, @books = pagy(
      Book.with_attached_image.include_authors.sorted_by_title,
      items: Settings.digit_10
    )
  end
end

class HomeController < ApplicationController
  def index
    return if current_account.blank?

    @books = {
      books_with_same_genre: current_account.books_with_same_genre,
      books_from_favorite_authors: current_account.books_from_favorite_authors,
      top_rated_books: fetch_books(:top_rated_books),
      most_borrowed_books: fetch_books(:most_borrowed_books)
    }
  end

  private

  def fetch_books scope
    Book.with_image_and_authors.public_send(scope)
  end
end

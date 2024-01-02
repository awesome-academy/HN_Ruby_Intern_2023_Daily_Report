module Admin::BooksHelper
  def format_isbn isbn
    isbn.delete("-").rjust(Settings.isbn_max_digits)
  end

  def populate_book book
    {
      cover: get_image(book, :image),
      title: book.title,
      description: book.description,
      publish_date: localize_date(book.publish_date, :year),
      isbn: format_isbn(book.isbn),
      updated_at: localize_date(book.updated_at, :long),
      publisher: book.publisher,
      authors: book.authors,
      genres: book.genres,
      book_path: admin_book_path(book),
      id: dom_id(book)
    }
  end

  def get_book_tab_headers book
    [
      {
        icon: :note,
        title: t("books.detail"),
        id: :book_detail,
        link: admin_book_path(book)
      }
    ]
  end
end

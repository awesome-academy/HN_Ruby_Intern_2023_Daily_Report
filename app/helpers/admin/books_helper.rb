module Admin::BooksHelper
  def format_isbn isbn
    isbn.delete("-").rjust(Settings.isbn_max_digits)
  end

  def populate_book book
    {
      cover: book.image,
      title: book.title,
      description: book.description,
      publish_date: localize_date(book.publish_date, :long),
      amount: book.amount,
      isbn: format_isbn(book.isbn),
      publisher: [book.publisher.id, book.publisher.name],
      authors: book.authors.pluck(:id, :name),
      genres: book.genres.pluck(:id, :name),
      book_path: admin_book_path(book),
      id: dom_id(book, :book)
    }
  end

  def render_books_tabs
    render "admin/shared/tab_content", group_id: :book, items: [
      {
        icon: :note,
        title: t("books.detail"),
        id: :detail,
        active: true,
        partial: "tab_detail"
      },
      {
        icon: :comment,
        title: t("books.review"),
        id: :review,
        active: false,
        partial: nil
      }
    ]
  end
end

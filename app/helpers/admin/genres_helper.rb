module Admin::GenresHelper
  def populate_genre genre
    {
      name: genre.name,
      description: genre.description,
      updated_at: localize_date(genre.updated_at, :long),
      genre_path: admin_genre_path(genre),
      id: dom_id(genre, :genre)
    }
  end

  def get_genre_tab_headers genre
    [
      {
        icon: :book,
        title: t("books._name"),
        id: :genre_books,
        link: admin_genre_path(genre)
      }
    ]
  end
end

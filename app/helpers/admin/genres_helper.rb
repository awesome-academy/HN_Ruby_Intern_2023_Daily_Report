module Admin::GenresHelper
  def populate_genre genre
    {
      name: genre.name,
      description: genre.description,
      genre_path: admin_genre_path(genre),
      id: dom_id(genre, :genre)
    }
  end

  def render_genres_tabs
    render "admin/shared/tab_content", group_id: :genre, items: [
      {
        icon: :note,
        title: t("genres.detail"),
        id: :detail,
        active: true,
        partial: nil
      },
      {
        icon: :comment,
        title: t("genres.review"),
        id: :review,
        active: false,
        partial: nil
      }
    ]
  end
end

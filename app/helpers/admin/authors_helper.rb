module Admin::AuthorsHelper
  def populate_author author
    {
      avatar: get_image(author),
      name: author.name,
      about: author.about,
      phone: author.phone,
      email: author.email,
      updated_at: localize_date(author.updated_at, :long),
      author_path: admin_author_path(author),
      id: dom_id(author)
    }
  end

  def get_author_tab_headers author
    [
      {
        icon: :book,
        title: t("books._name"),
        id: :author_books,
        link: admin_author_path(author)
      }
    ]
  end
end

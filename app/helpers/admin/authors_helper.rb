module Admin::AuthorsHelper
  def populate_author author
    {
      avatar: get_avatar(author),
      name: author.name,
      about: author.about,
      phone: author.phone,
      email: author.email,
      author_path: admin_author_path(author),
      id: dom_id(author, :author)
    }
  end

  def render_authors_tabs
    render "admin/shared/tab_content", group_id: :author, items: [
      {
        icon: :note,
        title: t("authors.detail"),
        id: :detail,
        active: true,
        partial: nil
      },
      {
        icon: :comment,
        title: t("authors.review"),
        id: :review,
        active: false,
        partial: nil
      }
    ]
  end
end

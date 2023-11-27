module Admin::PublishersHelper
  def populate_publisher publisher
    {
      name: publisher.name,
      about: publisher.about,
      address: publisher.address,
      email: publisher.email,
      updated_at: localize_date(publisher.updated_at, :long),
      publisher_path: admin_publisher_path(publisher),
      id: dom_id(publisher)
    }
  end

  def get_publisher_tab_headers publisher
    [
      {
        icon: :book,
        title: t("books._name"),
        id: :publisher_books,
        link: admin_publisher_path(publisher)
      }
    ]
  end
end

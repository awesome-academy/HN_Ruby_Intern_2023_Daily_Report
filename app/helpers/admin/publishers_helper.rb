module Admin::PublishersHelper
  def populate_publisher publisher
    {
      name: publisher.name,
      about: publisher.about,
      address: publisher.address,
      email: publisher.email,
      publisher_path: admin_publisher_path(publisher),
      id: dom_id(publisher, :publisher)
    }
  end

  def render_publishers_tabs
    render "admin/shared/tab_content", group_id: :publisher, items: [
      {
        icon: :note,
        title: t("publishers.detail"),
        id: :detail,
        active: true,
        partial: nil
      },
      {
        icon: :comment,
        title: t("publishers.review"),
        id: :review,
        active: false,
        partial: nil
      }
    ]
  end
end

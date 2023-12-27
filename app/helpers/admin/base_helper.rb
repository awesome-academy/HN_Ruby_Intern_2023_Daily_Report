module Admin::BaseHelper
  def format_time_ago string
    string = string.dup # incase string is frozen
    bad_words = [
      t("datetime.less_than"),
      t("datetime.about"),
      t("datetime.over"),
      t("datetime.almost")
    ]

    bad_words.each do |bad|
      string.gsub!("#{bad} ", "")
    end
    string
  end

  def time_ago date, suffix: false
    time_ago = format_time_ago time_ago_in_words(date)
    "#{time_ago}#{" #{t('datetime.ago')}" if suffix}" if date
  end

  def localize_date datetime, format = :short, date: true
    return unless datetime

    datetime = datetime.to_date if date
    l datetime, format:
  end

  def get_image obj, attribute = :avatar
    image = obj&.public_send(attribute)
    image&.attached? ? image : Settings.public_send("default_#{attribute}_path")
  end

  def get_link item, resource, for_text: :name, class: nil
    text = item&.public_send(for_text)
    link_to_if item, text,
               (send("admin_#{resource}_path", item) if item),
               class:, title: text
  end

  def render_table_header title, name = nil
    current = request.params[:sort] == name.to_s
    is_desc = params[:style]&.downcase == "desc"
    style = (is_desc ? :desc : :asc) if current
    new_style = style == :asc ? :desc : :asc
    link = url_for request.params.merge(style: new_style, sort: name)
    render "admin/shared/table_header", style:,
            sortable: name.present?, link:, title:
  end

  def navigate_to list: false, path: nil, path_text: nil, replace: false
    link_class = "btn btn-info mb-3"
    data = {turbo_action: :replace} if replace

    if path
      link_to path_text, path,
              class: link_class, data:
    elsif list
      link_to t("admin.misc.to_list"), url_for(action: :index),
              class: link_class, data:
    else
      link_to t("admin.misc.back"), "javascript:history.back()",
              class: link_class, data:
    end
  end

  def current_action? controller_name, action_name
    controller.controller_name == controller_name.to_s &&
      controller.action_name == action_name.to_s
  end

  def get_new_buttons
    [
      {controller: :books, icon: :book, title: t("books._name")},
      {controller: :authors, icon: :account, title: t("authors._name")},
      {controller: :genres, icon: :tag, title: t("genres._name")},
      {
        controller: :publishers,
        icon: :briefcase,
        title: t("publishers._name")
      }
    ]
  end

  def required? obj, attribute
    target = obj.instance_of?(Class) ? obj : obj.class
    target.validators_on(attribute)
          .map(&:class)
          .include?(ActiveRecord::Validations::PresenceValidator)
  end

  def validated_fields_of obj, validator =
    ActiveRecord::Validations::PresenceValidator
    target = obj.instance_of?(Class) ? obj : obj.class
    target.validators.select do |v|
      v.instance_of?(validator)
    end.map(&:attributes).flatten
  end

  def get_notification_icon notification
    status2icon = {
      info: {icon: "information-variant", color: :info},
      notice: {icon: "flag-variant", color: :warning},
      urgent: {icon: "flash", color: :danger}
    }
    status2icon[notification.status.to_sym]
  end

  def period_options
    options = [:year, :month, :week, :all]
    options.map do |name|
      [t("admin.misc.by_#{name}"), name]
    end
  end
end

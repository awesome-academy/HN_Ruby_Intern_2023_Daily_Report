module Admin::BaseHelper
  def format_time_ago string
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

  def time_ago date
    format_time_ago time_ago_in_words(date) if date
  end

  def localize_date datetime, format = :long
    l(datetime.to_date, format:) if datetime
  end

  def get_avatar account
    avatar = account&.avatar
    avatar&.attached? ? avatar : Settings.default_avatar_path
  end

  # Should use this if need a default display value if not nil
  def get_attr obj, attribute
    obj&.send(attribute) || Settings.display_for_nil
  end
end

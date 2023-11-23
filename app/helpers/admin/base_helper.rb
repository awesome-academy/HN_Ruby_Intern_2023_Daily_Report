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

  def get_avatar account
    avatar = account&.avatar
    avatar.attached? ? avatar : Settings.default_avatar_path
  end
end

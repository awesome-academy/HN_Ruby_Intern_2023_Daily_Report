class Publisher < ApplicationRecord
  has_many :books, dependent: :nullify

  validates :name, presence: true, length: {
    maximum: Settings.name_max_len
  }
  validates :about, presence: true, length: {
    maximum: Settings.desc_max_len
  }
  validates :address, presence: true, length: {
    maximum: Settings.desc_max_len
  }
  validates :email, length: {maximum: Settings.digit_255},
                    format: Settings.valid_email_regex,
                    allow_blank: true

  scope :bquery, lambda {|q|
    where("publishers.name LIKE ?", "%#{q}%")
      .or(where("publishers.email LIKE ?", "%#{q}%"))
      .or(where("publishers.address LIKE ?", "%#{q}%"))
      .or(where("publishers.about LIKE ?", "%#{q}%"))
  }
end

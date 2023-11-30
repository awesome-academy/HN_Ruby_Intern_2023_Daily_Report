class Author < ApplicationRecord
  before_save :downcase_email
  before_validation :format_phone

  has_many :book_authors, dependent: :destroy
  has_many :books, through: :book_authors
  has_many :followings, class_name: AuthorFollower.name,
                        dependent: :destroy
  has_many :followers, through: :followings

  has_one_attached :avatar

  validates :name, presence: true, length: {
    maximum: Settings.name_max_len
  }
  validates :about, presence: true, length: {
    maximum: Settings.desc_max_len
  }
  validates :email, length: {maximum: Settings.digit_255},
                    format: Settings.valid_email_regex,
                    allow_blank: true
  validates :phone, format: Settings.valid_phone_regex,
                    allow_blank: true

  validates :avatar,
            content_type: {
              in: Settings.image_type,
              message: I18n.t("validations.image_type_valid")
            }

  scope :bquery, lambda {|q|
    where("authors.name LIKE ?", "%#{q}%")
      .or(where("authors.email LIKE ?", "%#{q}%"))
      .or(where("authors.about LIKE ?", "%#{q}%"))
  }

  private

  def format_phone
    phone.gsub!(/[ .-]/, "")
  end
end

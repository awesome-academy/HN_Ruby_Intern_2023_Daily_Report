class Author < ApplicationRecord
  has_many :book_authors, dependent: :destroy
  has_many :books, through: :book_authors
  has_many :followings, class_name: AuthorFollower.name,
                        dependent: :destroy
  has_many :followers, through: :followings

  has_one_attached :avatar

  validates :avatar,
            content_type: {
              in: Settings.validations.image_type,
              message: I18n.t("validations.image_type_valid")
            }

  scope :bquery, lambda {|q|
    where("authors.name LIKE ?", "%#{q}%")
      .or(where("authors.email LIKE ?", "%#{q}%"))
      .or(where("authors.about LIKE ?", "%#{q}%"))
  }
end

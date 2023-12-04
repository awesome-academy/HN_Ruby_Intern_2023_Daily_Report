class Book < ApplicationRecord
  belongs_to :publisher
  has_many :book_authors, dependent: :destroy
  has_many :authors, through: :book_authors
  has_many :book_genres, dependent: :destroy
  has_many :genres, through: :book_genres
  has_many :favorites, class_name: BookFavorite.name,
                       dependent: :destroy
  has_many :favoriters, through: :favorites
  has_many :borrowings, class_name: BorrowItem.name,
                        dependent: :destroy
  has_many :borrow_requests, through: :borrowings,
                             source: :request
  has_many :rates, class_name: BookRate.name,
                   dependent: :destroy
  has_many :raters, through: :rates
  has_many :comments, class_name: BookComment.name,
                      dependent: :destroy
  has_many :commenters, through: :comments

  has_one_attached :image

  validates :title, :description, :amount,
            :publish_date, :isbn, :publisher, presence: true

  validates :title, length: {maximum: Settings.validations.title_max_len}
  validates :amount, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0
  }
  validates :publish_date, datetime: {to: :date, check: :past}
  validates :isbn, format: {
    with: Settings.validations.isbn_regex,
    message: I18n.t("validations.isbn_valid")
  }
  validates :image,
            content_type: {
              in: Settings.validations.image_type,
              message: I18n.t("validations.image_type_valid")
            }

  scope :sorted_by_title, ->{order(title: :asc)}
  scope :ordered_and_grouped_by_first_letter,
        ->{order(:title).group_by{|book| book.title[0].upcase}}
  scope :include_authors, ->{includes(:authors)}

  scope :includes_info, lambda {\
    includes(:authors, :publisher, :genres)
      .with_attached_image
  }
  scope :available, ->{where is_active: true}
  scope :bquery, lambda {|q|
    where("books.title LIKE ?", "%#{q}%")
      .or(where("books.isbn LIKE ?", "%#{q}%"))
      .references(:authors, :publisher, :genres)
      .or(Author.bquery(q))
      .or(Genre.bquery(q))
      .or(Publisher.bquery(q))
  }
end

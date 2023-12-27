class Book < ApplicationRecord
  belongs_to :publisher, optional: true
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

  validates :title, :description, :amount, :borrowed_count,
            :publish_date, :isbn, presence: true
  validates :title, uniqueness: {case_sensitive: false},
                    length: {maximum: Settings.title_max_len}
  validates :amount, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0
  }
  validates :publish_date, datetime: {to: :date, check: :past}
  validates :isbn, format: {
    with: Settings.isbn_regex,
    message: I18n.t("validations.isbn_valid")
  }, uniqueness: true
  validates :image,
            content_type: {
              in: Settings.image_type,
              message: I18n.t("validations.image_type_valid")
            }
  validate :borrowed_count_below_amount

  scope :newest_book, ->{order(created_at: :desc)}
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
      .or(where("authors.name LIKE ?", "%#{q}%"))
      .or(where("genres.name LIKE ?", "%#{q}%"))
      .or(where("publishers.name LIKE ?", "%#{q}%"))
  }
  scope :borrowable, ->{where("amount >= borrowed_count")}
  scope :remain_least, ->{order(Arel.sql("amount - borrowed_count ASC"))}
  scope :by_first_letter, ->(letter){where("title LIKE ?", "#{letter}%")}

  def update_relation_with_ids name, ids
    attribute = send "book_#{name}s"
    attribute.clear
    attribute.create(ids.map{|id| {"#{name}_id": id}})
  end

  def remain
    amount - borrowed_count
  end

  class << self
    def ransackable_attributes _auth_object = nil
      %w(title description isbn created_at)
    end

    def ransackable_associations _auth_object = nil
      %w(authors book_authors book_genres genres publisher)
    end
  end

  private

  def borrowed_count_below_amount
    errors.add :borrowed_count, I18n.t("validations.not_borrowable") if
      borrowed_count.negative? || (amount && amount < borrowed_count)
  end
end

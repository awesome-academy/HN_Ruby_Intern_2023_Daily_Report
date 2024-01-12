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
                             source: :borrow_info
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
  scope :with_image_and_authors, ->{with_attached_image.include_authors}
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
  scope :top_rated_books, lambda {|limit = 6|
    joins(:comments)
      .select("books.*, AVG(book_comments.star_rate) as avg_star_rate")
      .group("books.id")
      .order("avg_star_rate DESC")
      .limit(limit)
  }
  scope :most_borrowed_books, lambda {|limit = 6|
    order(borrowed_count: :desc).limit(limit)
  }

  ransack_alias :title, :title_or_description_or_isbn_or_authors_name_or_publisher_name_or_genres_name # rubocop:disable Layout/LineLength

  def remain
    amount - borrowed_count
  end

  def average_ratings
    comments.average(:star_rate).to_f.round(1)
  end

  def rating_details value
    total_comments = comments.count
    count = comments.where(star_rate: value).count
    percentage = (count.to_f / total_comments) * 100

    {percentage:, count:}
  end

  class << self
    def ransackable_attributes _auth_object = nil
      %w(title description isbn created_at)
    end

    def ransackable_associations _auth_object = nil
      %w(authors book_authors book_genres genres publisher)
    end
  end

  def update_relation publisher_id, author_ids, genre_ids
    transaction do
      update(publisher_id:) if publisher_id
      update_relation_with_ids(:author, author_ids) if author_ids
      update_relation_with_ids(:genre, genre_ids) if genre_ids
    end
    true
  rescue ActiveRecord::RecordInvalid => e
    errors.merge! e.record.errors
    reload
    false
  end

  def delete_temporarily
    return false unless is_active

    update is_active: false
  end

  private

  def borrowed_count_below_amount
    errors.add :borrowed_count, I18n.t("validations.not_borrowable") if
      borrowed_count.negative? || (amount && amount < borrowed_count)
  end

  def update_relation_with_ids name, ids
    attribute = send "book_#{name}s"
    attribute.clear
    attribute.create!(ids.map{|id| {"#{name}_id": id}})
  end
end

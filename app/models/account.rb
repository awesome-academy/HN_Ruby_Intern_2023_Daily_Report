class Account < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  before_save :downcase_email

  has_one :user_info, dependent: :nullify, inverse_of: :account
  has_one_attached :avatar
  accepts_nested_attributes_for :user_info

  has_many :borrow_requests, class_name: BorrowInfo.name,
                             dependent: :destroy
  has_many :author_followings, class_name: AuthorFollower.name,
                               dependent: :destroy
  has_many :favorite_authors, through: :author_followings,
                              source: :author
  has_many :book_followings, class_name: BookFavorite.name,
                             dependent: :destroy
  has_many :favorite_books, through: :book_followings,
                            source: :book
  has_many :rates, class_name: BookRate.name,
                   dependent: :destroy
  has_many :rated_books, through: :rates,
                         source: :book
  has_many :comments, class_name: BookComment.name,
                      dependent: :destroy
  has_many :commented_books, through: :comments,
                             source: :book
  has_many :notifications, dependent: :destroy

  validates :email, presence: true, length: {maximum: Settings.digit_255},
                    format: Settings.valid_email_regex,
                    uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {in: 6..20}, allow_nil: true
  validates :username, presence: true, length: {maximum: Settings.digit_50},
                       uniqueness: true

  scope :exclude, ->(account){where.not(id: account.id)}
  scope :includes_info, ->{includes(:user_info).with_attached_avatar}
  scope :only_activated, ->{where(is_activated: true)}
  scope :only_admin, ->{where(is_admin: true)}
  scope :not_admin, ->{where(is_admin: false)}
  scope :bquery, lambda {|q|
    where("accounts.username LIKE ?", "%#{q}%")
      .or(where("accounts.email LIKE ?", "%#{q}%"))
      .references(:user_info)
      .or(UserInfo.bquery(q))
  }

  def follow author
    favorite_authors << author
  end

  def unfollow author
    favorite_authors.delete author
  end

  def following? author
    favorite_authors.include? author
  end

  def active_for_authentication?
    super && is_active?
  end

  def inactive_message
    :locked
  end

  def notification_for_me status, content, link: nil
    Notification.create status:, content:, link:, account_id: id
  end

  def send_inactive_email reason
    UserMailer.with(user: self, reason:).notify_inactive.deliver_later
  end

  def change_is_active_to is_active
    return if self.is_active == is_active

    update_attribute :is_active, is_active
  end

  def books_with_same_genre limit = 6
    return [] if borrow_requests.blank?

    genre_ids = borrow_requests.joins(books: :genres).pluck("genres.id").uniq
    fetch_books(:genres, genre_ids, limit)
  end

  def books_from_favorite_authors limit = 6
    fetch_books(:authors, favorite_authors.ids, limit)
  end

  def activate
    self.is_active = true
    self.is_activated = true
    save!
  end

  private

  def fetch_books association, ids, limit
    Book.with_image_and_authors
        .joins(association)
        .where(association => {id: ids})
        .limit(limit)
  end
end

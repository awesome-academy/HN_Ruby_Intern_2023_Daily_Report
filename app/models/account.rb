class Account < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
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

  validates :email, presence: true, length: {maximum: Settings.digit_255},
                    format: Settings.valid_email_regex,
                    uniqueness: {case_sensitive: false}
  validates :password, presence: true, length: {in: 6..20}, allow_nil: true
  validates :username, presence: true, length: {maximum: Settings.digit_50},
                       uniqueness: true

  scope :exclude, ->(account){where.not(id: account.id)}
  scope :includes_info, ->{includes(:user_info).with_attached_avatar}
  scope :only_activated, ->{where(is_activated: true)}
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
end

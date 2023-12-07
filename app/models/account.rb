class Account < ApplicationRecord
  before_save :downcase_email

  attr_accessor :remember_token

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

  has_secure_password

  def remember
    self.remember_token = self.class.new_token
    update_attribute :remember_digest, self.class.digest(remember_token)
  end

  # Forgets a user.
  def forget
    update_attribute :remember_digest, nil
  end

  # Returns true if the given token matches the attribute digest.
  def token_match? attribute, token
    digest = send "#{attribute}_digest"
    return false if digest.nil?

    match_digest? digest, token
  end

  class << self
    # Returns the hash digest of the given string.
    def digest str
      cost = BCrypt::Engine.cost
      cost = BCrypt::Engine::MIN_COST if ActiveModel::SecurePassword.min_cost
      BCrypt::Password.create str, cost:
    end

    # Returns a random token.
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  private

  def match_digest? digest, token
    BCrypt::Password.new(digest).is_password? token
  end
end

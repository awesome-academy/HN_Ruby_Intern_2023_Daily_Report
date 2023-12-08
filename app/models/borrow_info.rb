class BorrowInfo < ApplicationRecord
  enum :status, %i(pending approved rejected returned)

  belongs_to :account
  has_one :response, class_name: BorrowResponse.name,
                     dependent: :destroy
  has_many :borrowings, class_name: BorrowItem.name,
                        dependent: :destroy
  has_many :books, through: :borrowings

  validates :start_at, :end_at, :status, :remain_turns, presence: true

  validate :start_at_validation, :end_at_validation

  def start_at_validation
    return if start_at && start_at >= Date.current

    errors.add(:start_at, I18n.t("date_greater_than_today"))
  end

  def end_at_validation
    if end_at && end_at < start_at + 3
      errors.add(:end_at, I18n.t("date_minimum_3_days"))
    elsif end_at && end_at > start_at + 10
      errors.add(:end_at, I18n.t("date_maximum_10_days"))
    end
  end

  scope :due_first, ->{order(end_at: :desc)}
  scope :includes_user, lambda {\
    includes(account: [{avatar_attachment: [:blob]}, user_info: []])
  }
  scope :includes_response, ->{includes(:response)}
  scope :bquery, lambda {|q|
    references(:account, :user_info)
      .where("accounts.username LIKE ?", "%#{q}%")
      .or(Account.where("accounts.email LIKE ?", "%#{q}%"))
      .or(UserInfo.where("user_infos.name LIKE ?", "%#{q}%"))
  }
  scope :history, ->{rejected.or(BorrowInfo.returned)}

  def finished?
    rejected? || returned?
  end
end

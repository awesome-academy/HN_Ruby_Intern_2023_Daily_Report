class BorrowInfo < ApplicationRecord
  enum :status, %i(pending approved rejected canceled returned)

  belongs_to :account
  has_one :response, class_name: BorrowResponse.name,
                     dependent: :destroy
  has_many :borrowings, class_name: BorrowItem.name,
                        dependent: :destroy
  has_many :books, through: :borrowings

  validates :start_at, :end_at, :status, :turns, presence: true
  validate :start_at_validation, :end_at_validation, on: :create
  validates :renewal_at, presence: true, on: :update
  validate :renewal_at_validation, on: :update
  validates :turns, numericality: {less_than: Settings.digit_5.to_i}

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
  scope :for_account, ->(account_id){where(account_id:)}
  scope :desc_order, ->{order(updated_at: :desc)}

  after_update :after_change_status, if: :saved_change_to_status?

  def start_at_validation
    return if start_at && start_at >= Date.current

    errors.add(:start_at, I18n.t("date_greater_than_today"))
  end

  def end_at_validation
    if start_at && end_at && end_at > start_at + Settings.digit_10
      errors.add(:end_at, I18n.t("date_maximum_10_days"))
    elsif start_at && end_at && end_at <= start_at
      errors.add(:end_at, I18n.t("return_date_greater_than_borrow_date"))
    end
  end

  def renewal_at_validation
    if renewal_at && renewal_at <= end_at
      errors.add(:renewal_at, I18n.t("renewal_date_greater_than_return_date"))
    elsif renewal_at && renewal_at > end_at + Settings.digit_10
      errors.add(:renewal_at, I18n.t("renewal_date_maximum_10_days"))
    end
  end

  def finished?
    rejected? || returned?
  end

  def type
    turns.positive? ? :incrementing : :new
  end

  def overdue?
    returned? && updated_at > end_at
  end

  def penalty
    exceed = (updated_at.to_date - end_at.to_date).to_i
    overdue? ? I18n.t("penalty_per_overdue") * exceed : 0
  end

  def add_to_book_borrowed_count value
    transaction do
      books.each do |book|
        book.borrowed_count += value
        book.save!
      end
    end
  end

  def self.ransackable_attributes _auth_object = nil
    %w(status id start_at end_at turns)
  end

  private

  def after_change_status
    link = Rails.application.routes.url_helpers.borrow_info_path(id:)
    if %w(approved rejected).include? status
      BorrowMailer.with(borrow: self).notify_result.deliver_later
      account&.notification_for_me :info,
                                   "notifications.borrow_#{status}",
                                   link:
    elsif overdue?
      account&.notification_for_me :notice,
                                   "notifications.borrow_returned_overdue",
                                   link:
    end
  end
end

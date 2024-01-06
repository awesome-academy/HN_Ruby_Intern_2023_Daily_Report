class BorrowInfo < ApplicationRecord
  enum :status, %i(pending approved rejected canceled returned renewing)

  belongs_to :account
  has_one :response, class_name: BorrowResponse.name,
                     dependent: :destroy
  has_many :borrowings, class_name: BorrowItem.name,
                        dependent: :destroy
  has_many :books, through: :borrowings

  validates :start_at, :end_at, :status, :turns, presence: true
  validate :start_at_validation, :end_at_validation, on: :create
  validates :renewal_at, presence: true, if: ->(borrow){borrow.renewing?}
  validate :renewal_at_validation, on: :update
  validates :turns, numericality: {less_than_or_equal_to: Settings.digit_5.to_i}

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
  scope :history, ->{where.not(done_at: nil)}
  scope :waiting, ->{pending.or(BorrowInfo.renewing)}
  scope :borrowing, ->{approved.or(BorrowInfo.rejected.where(done_at: nil))}
  scope :for_account, ->(account_id){where(account_id:)}
  scope :desc_order, ->{order(updated_at: :desc)}
  scope :group_status, ->(status){where(status:) if status != "all"}

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

  def borrowing?
    approved? || (rejected? && !finished?)
  end

  def finished?
    done_at.present?
  end

  def overdue?
    (done_at || Time.zone.today) > end_at
  end

  def out_of_turns?
    turns >= Settings.max_renewals
  end

  def out_of_renew_date?
    Time.zone.today > end_at
  end

  def return_exceed
    final = done_at&.to_date || Time.zone.today
    (final - end_at.to_date).to_i
  end

  def penalty
    overdue? ? I18n.t("penalty_per_overdue") * return_exceed : 0
  end

  def perform_action action, *args
    transaction do
      send action, *args
    end
  rescue ActiveRecord::RecordInvalid
    reload
    false
  end

  def self.ransackable_attributes _auth_object = nil
    %w(status id start_at end_at turns)
  end

  private

  def add_to_book_borrowed_count value
    transaction do
      update_books = books.map do |b|
        raise ActiveRecord::Rollback unless b.is_active

        [b.id, {
          id: b.id,
          borrowed_count: b.borrowed_count + value
        }]
      end.to_h
      Book.update! update_books.keys, update_books.values
    end
  end

  def approve
    return unless %w(pending renewing).include? status

    if renewing?
      self.end_at = renewal_at
      self.renewal_at = nil
      self.turns += 1
    else
      return unless add_to_book_borrowed_count(1)
    end
    self.status = :approved
    save!
  end

  def reject
    return unless %w(pending renewing).include? status

    self.done_at = Time.zone.today if pending?
    self.renewal_at = nil
    self.status = :rejected
    save!
  end

  def return
    return unless %w(approved rejected).include? status
    return if done_at

    self.done_at = Time.zone.now
    return unless add_to_book_borrowed_count(-1)

    self.status = :returned
    save!
  end

  def renew end_date
    return unless %w(approved).include? status

    self.status = :renewing
    self.renewal_at = end_date
    save!
  end

  def cancel
    return unless %w(pending renewing).include? status

    if pending?
      self.status = :canceled
      self.done_at = Time.zone.now
    else
      self.renewal_at = nil
      self.status = :approved
    end
    save!
  end
end

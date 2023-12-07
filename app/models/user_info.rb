class UserInfo < ApplicationRecord
  enum :gender, %i(male female others)
  belongs_to :account, inverse_of: :user_info

  scope :bquery, lambda {|q|
    where("user_infos.name LIKE ?", "%#{q}%")
      .or(where("user_infos.phone LIKE ?", "%#{q}%"))
  }

  validates :name, :gender, :address, :phone, :citizen_id, :dob, presence: true
  validates :name, length: {maximum: Settings.digit_50}
  validates :phone, length: {is: Settings.digit_10}
end

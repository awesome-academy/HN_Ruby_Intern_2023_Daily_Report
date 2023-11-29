class UserInfo < ApplicationRecord
  enum :gender, %i(male female others)
  belongs_to :account

  scope :bquery, lambda {|q|
    where("user_infos.name LIKE ?", "%#{q}%")
      .or(where("user_infos.phone LIKE ?", "%#{q}%"))
  }
end

class Notification < ApplicationRecord
  enum :status, %i(info notice urgent)

  scope :for_all, ->(account){where(account_id: [account&.id, nil])}
  scope :for_me, ->(account){where(account_id: account&.id)}
  scope :unchecked, ->{where(checked: false)}
  scope :created_order, ->{order(created_at: :desc)}
end

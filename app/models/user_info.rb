class UserInfo < ApplicationRecord
  enum :gender, %i(male female others)
  has_one :account, dependent: :nullify
end

class UserInfo < ApplicationRecord
  enum :gender, %i(male female others)
  belongs_to :account
end

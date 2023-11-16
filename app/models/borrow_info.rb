class BorrowInfo < ApplicationRecord
  enum :status, %i(prepend approved rejected returned),
       default: :prepend

  belongs_to :account
  has_one :response, class_name: BorrowResponse.name,
                     dependent: destroy
  has_many :borrowings, class_name: BorrowItem.name,
                        dependent: :destroy
  has_many :books, through: :borrowings
end

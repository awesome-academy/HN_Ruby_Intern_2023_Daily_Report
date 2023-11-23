class BorrowInfo < ApplicationRecord
  enum :status, %i(pending approved rejected returned)

  belongs_to :account
  has_one :response, class_name: BorrowResponse.name,
                     dependent: :destroy
  has_many :borrowings, class_name: BorrowItem.name,
                        dependent: :destroy
  has_many :books, through: :borrowings
end

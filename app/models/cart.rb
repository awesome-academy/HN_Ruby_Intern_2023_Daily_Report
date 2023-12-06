class Cart < ApplicationRecord
  has_many :borrowings, class_name: BorrowItem.name, dependent: :destroy
  has_many :books, through: :borrowings
end

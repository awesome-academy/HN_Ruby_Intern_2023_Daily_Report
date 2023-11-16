class BorrowItem < ApplicationRecord
  belongs_to :borrow_info
  belongs_to :book, class_name: Book.name
end

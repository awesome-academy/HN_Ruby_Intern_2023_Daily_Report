class BorrowItem < ApplicationRecord
  belongs_to :borrow_info, optional: true
  belongs_to :book, class_name: Book.name
  belongs_to :cart
end

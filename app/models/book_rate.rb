class BookRate < ApplicationRecord
  belongs_to :rater, class_name: Account.name,
                     foreign_key: :account_id
  belongs_to :book, class_name: Book.name
end

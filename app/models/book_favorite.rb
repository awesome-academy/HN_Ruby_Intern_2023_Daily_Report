class BookFavorite < ApplicationRecord
  belongs_to :favoriter, class_name: Account.name,
                         foreign_key: :account_id
  belongs_to :book, class_name: Book.name
end

class BookGenre < ApplicationRecord
  belongs_to :genre, class_name: Genre.name
  belongs_to :book, class_name: Book.name
end

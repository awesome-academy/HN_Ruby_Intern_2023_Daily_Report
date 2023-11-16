class BookAuthor < ApplicationRecord
  belongs_to :author, class_name: Author.name
  belongs_to :book, class_name: Book.name
end

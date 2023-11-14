class Author < ApplicationRecord
  has_many :book_authors, dependent: :destroy
  has_many :books, through: :book_authors
  has_many :followings, class_name: AuthorFollower.name,
                        dependent: :destroy
  has_many :followers, through: :followings
end

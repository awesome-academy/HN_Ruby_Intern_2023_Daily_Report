class Account < ApplicationRecord
  belongs_to :user_info
  has_many :borrow_requests, class_name: BorrowInfo.name,
                             dependent: :destroy
  has_many :author_followings, class_name: AuthorFollower.name,
                               dependent: :destroy
  has_many :favorite_authors, through: :author_followings,
                              source: :author
  has_many :book_followings, class_name: BookFavorite.name,
                             dependent: :destroy
  has_many :favorite_books, through: :book_followings,
                            source: :book
  has_many :rates, class_name: BookRate.name,
                   dependent: :destroy
  has_many :rated_books, through: :rates,
                         source: :book
  has_many :comments, class_name: BookComment.name,
                      dependent: :destroy
  has_many :commented_books, through: :comments,
                             source: :book
end

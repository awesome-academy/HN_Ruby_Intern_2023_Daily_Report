class Book < ApplicationRecord
  belongs_to :publisher
  has_many :book_authors, dependent: :destroy
  has_many :authors, through: :book_authors
  has_many :book_genres, dependent: :destroy
  has_many :genres, through: :book_genres
  has_many :favorites, class_name: BookFavorite.name,
                       dependent: :destroy
  has_many :favoriters, through: :favorites
  has_many :borrowings, class_name: BorrowItem.name,
                        dependent: :destroy
  has_many :borrow_requests, through: :borrowings,
                             source: :request
  has_many :rates, class_name: BookRate.name,
                   dependent: :destroy
  has_many :raters, through: :rates
  has_many :comments, class_name: BookComment.name,
                      dependent: :destroy
  has_many :commenters, through: :comments
  has_one_attached :image

  scope :sorted_by_title, ->{order(title: :asc)}
  scope :ordered_and_grouped_by_first_letter,
        ->{order(:title).group_by{|book| book.title[0].upcase}}
  scope :include_authors, ->{includes(:authors)}
end

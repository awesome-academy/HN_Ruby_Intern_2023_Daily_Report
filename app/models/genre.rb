class Genre < ApplicationRecord
  has_many :book_genres, dependent: :destroy
  has_many :books, through: :book_genres

  validates :name, uniqueness: true

  scope :bquery, ->(q){where("genres.name LIKE ?", "%#{q}%")}
end

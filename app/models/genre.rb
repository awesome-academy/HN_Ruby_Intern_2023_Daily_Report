class Genre < ApplicationRecord
  has_many :book_genres, dependent: :destroy
  has_many :books, through: :book_genres

  validates :name, uniqueness: true

  scope :bquery, lambda {|q|
    where("genres.name LIKE ?", "%#{q}%")
      .or(where("genres.description LIKE ?", "%#{q}%"))
  }
end

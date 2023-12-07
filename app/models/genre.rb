class Genre < ApplicationRecord
  has_many :book_genres, dependent: :destroy
  has_many :books, through: :book_genres

  validates :name, presence: true, uniqueness: true, length: {
    maximum: Settings.genre_max_len
  }
  validates :description, presence: true, length: {
    maximum: Settings.desc_max_len
  }

  scope :bquery, lambda {|q|
    where("genres.name LIKE ?", "%#{q}%")
      .or(where("genres.description LIKE ?", "%#{q}%"))
  }
end

class Publisher < ApplicationRecord
  has_many :books, dependent: :nullify

  scope :bquery, ->(q){where("publishers.name LIKE ?", "%#{q}%")}
end

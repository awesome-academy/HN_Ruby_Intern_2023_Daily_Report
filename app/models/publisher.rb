class Publisher < ApplicationRecord
  has_many :books, dependent: :nullify

  scope :bquery, lambda {|q|
    where("publishers.name LIKE ?", "%#{q}%")
      .or(where("publishers.email LIKE ?", "%#{q}%"))
      .or(where("publishers.address LIKE ?", "%#{q}%"))
      .or(where("publishers.about LIKE ?", "%#{q}%"))
  }
end

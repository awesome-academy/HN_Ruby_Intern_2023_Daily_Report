class BookSerializer < ApplicationSerializer
  attributes :id, :title, :description, :publish_date, :isbn

  attribute :amount, if: :admin_only
  attribute :borrowed_count, key: :borrowed, if: :admin_only
  attribute :is_active, key: :available

  has_many :authors, serializer: ObjectPreviewSerializer
  has_many :genres, serializer: ObjectPreviewSerializer
  has_one :publisher, serializer: ObjectPreviewSerializer
  has_one :image, key: :cover do |serializer|
    serializer.link_for_attachment :image
  end
end

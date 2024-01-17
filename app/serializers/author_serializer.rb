class AuthorSerializer < ApplicationSerializer
  attributes :id, :name, :email, :phone, :about

  has_one :avatar do |serializer|
    serializer.link_for_attachment :avatar
  end
end

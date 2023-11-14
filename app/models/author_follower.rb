class AuthorFollower < ApplicationRecord
  belongs_to :follower, class_name: Account.name,
                        foreign_key: :account_id
  belongs_to :author, class_name: Author.name
end

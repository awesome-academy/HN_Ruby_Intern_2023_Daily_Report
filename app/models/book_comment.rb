class BookComment < ApplicationRecord
  belongs_to :commenter, class_name: Account.name,
                         foreign_key: :account_id
  belongs_to :book, class_name: Book.name
  has_rich_text :content

  validates :content, presence: true
  validates :star_rate, presence: true
  validates :star_rate, numericality: {in: 1..Settings.digit_5},
            allow_blank: true

  scope :include_accounts_with_avatar,
        ->{includes(commenter: {avatar_attachment: :blob})}
  scope :newest_comments, ->{order(created_at: :desc)}

  class << self
    def ransackable_attributes _auth_object = nil
      %w(star_rate)
    end

    def ransackable_associations _auth_object = nil
      %w(book commenter)
    end
  end
end

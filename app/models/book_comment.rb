class BookComment < ApplicationRecord
  belongs_to :commenter, class_name: Account.name,
                         foreign_key: :account_id
  belongs_to :book, class_name: Book.name
  has_rich_text :content

  validate :comment_content_validate

  scope :include_accounts_with_avatar,
        ->{includes(commenter: {avatar_attachment: :blob})}
  scope :newest_comments, ->{order(created_at: :desc)}

  private

  def comment_content_validate
    return if content.present?

    errors.add(:content, I18n.t("comment_cannot_empty"))
  end
end

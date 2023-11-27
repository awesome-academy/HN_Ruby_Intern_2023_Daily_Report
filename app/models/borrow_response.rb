class BorrowResponse < ApplicationRecord
  belongs_to :request, class_name: BorrowInfo.name,
                       foreign_key: :borrow_info_id
  scope :newest_limit, ->(n = Settings.digit_10){newest.limit(n)}
end

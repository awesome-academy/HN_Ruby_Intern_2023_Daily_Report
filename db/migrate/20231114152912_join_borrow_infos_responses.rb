class JoinBorrowInfosResponses < ActiveRecord::Migration[7.0]
  def change
    add_reference :borrow_responses, :borrow_info,
                  foreign_key: true, null: false, index: true
  end
end

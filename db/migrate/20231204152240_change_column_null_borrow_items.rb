class ChangeColumnNullBorrowItems < ActiveRecord::Migration[7.0]
  def change
    change_column_null :borrow_items, :borrow_info_id, true
  end
end

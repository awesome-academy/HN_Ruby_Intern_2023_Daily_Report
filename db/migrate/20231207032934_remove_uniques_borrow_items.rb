class RemoveUniquesBorrowItems < ActiveRecord::Migration[7.0]
  def change
    remove_index :borrow_items, [:cart_id, :borrow_info_id], unique: true
    add_index :borrow_items, [:cart_id, :borrow_info_id]
    change_column_null :borrow_items, :cart_id, true
  end
end

class AddCartToBorrowItems < ActiveRecord::Migration[7.0]
  def change
    add_reference :borrow_items, :cart, null: false, foreign_key: true
    add_index :borrow_items, [:cart_id, :borrow_info_id], unique: true
  end
end

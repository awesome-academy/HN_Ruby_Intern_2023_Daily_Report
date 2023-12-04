class AddQuantityToBorrowItems < ActiveRecord::Migration[7.0]
  def change
    add_column :borrow_items, :quantity, :integer, null: false, default: 1
  end
end

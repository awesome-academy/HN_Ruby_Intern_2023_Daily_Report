class JoinBooksBorrowInfosBorrowedItem < ActiveRecord::Migration[7.0]
  def change
    create_table :borrow_items do |t|
      t.belongs_to :book, null: false, foreign_key: true
      t.belongs_to :borrow_info, null: false, foreign_key: true

      t.timestamps
    end
    add_index :borrow_items, [:book_id, :borrow_info_id], unique: true
  end
end

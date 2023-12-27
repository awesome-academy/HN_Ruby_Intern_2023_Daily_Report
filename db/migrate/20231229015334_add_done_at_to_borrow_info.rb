class AddDoneAtToBorrowInfo < ActiveRecord::Migration[7.0]
  def change
    add_column :borrow_infos, :done_at, :datetime, null: true
  end
end

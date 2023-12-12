class AddBorrowedCountToBook < ActiveRecord::Migration[7.0]
  def change
    add_column :books, :borrowed_count, :integer, default: 0
  end
end

class ChangeBorrowInfosDataTypes < ActiveRecord::Migration[7.0]
  def up
    change_column :borrow_infos, :start_at, :date
    change_column :borrow_infos, :end_at, :date
  end

  def down; end
end

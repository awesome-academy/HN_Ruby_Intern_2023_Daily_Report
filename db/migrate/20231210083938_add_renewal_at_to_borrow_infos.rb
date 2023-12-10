class AddRenewalAtToBorrowInfos < ActiveRecord::Migration[7.0]
  def change
    add_column :borrow_infos, :renewal_at, :date
  end
end

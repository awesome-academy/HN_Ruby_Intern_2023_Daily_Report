class JoinBorrowInfosAccounts < ActiveRecord::Migration[7.0]
  def change
    add_reference :borrow_infos, :account,
                  foreign_key: true, index: true, null: false
  end
end

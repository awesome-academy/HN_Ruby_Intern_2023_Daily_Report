class AddDefaultValuesToBorrowInfos < ActiveRecord::Migration[7.0]
  def change
    change_column_default :borrow_infos, :status, from: nil, to: 0
    change_column_default :borrow_infos, :remain_turns, from: nil, to: 5
  end
end

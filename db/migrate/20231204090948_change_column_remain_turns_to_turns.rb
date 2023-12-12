class ChangeColumnRemainTurnsToTurns < ActiveRecord::Migration[7.0]
  def change
    remove_column :borrow_infos, :remain_turns
    add_column :borrow_infos, :turns, :integer, null: false, default: 0
  end
end

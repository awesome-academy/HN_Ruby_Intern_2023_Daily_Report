class CreateBorrowInfos < ActiveRecord::Migration[7.0]
  def change
    create_table :borrow_infos do |t|
      t.datetime :start_at, null: false
      t.datetime :end_at, null: false
      t.integer :status, null: false
      t.integer :remain_turns, null: false

      t.timestamps
    end

    add_index :borrow_infos, :start_at
    add_index :borrow_infos, :end_at
  end
end

class DropTableBookRates < ActiveRecord::Migration[7.0]
  def change
    drop_table :book_rates do |t|
      t.belongs_to :book, null: false, foreign_key: true
      t.belongs_to :account, null: false, foreign_key: true

      t.integer :value, null: false
      t.timestamps
    end
  end
end

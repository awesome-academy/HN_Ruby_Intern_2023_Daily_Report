class JoinBooksAccountsRate < ActiveRecord::Migration[7.0]
  def change
    create_table :books_rates do |t|
      t.belongs_to :book, null: false, foreign_key: true
      t.belongs_to :account, null: false, foreign_key: true

      t.integer :value, null: false
      t.timestamps
    end
    add_index :books_rates, [:book_id, :account_id], unique: true
  end
end

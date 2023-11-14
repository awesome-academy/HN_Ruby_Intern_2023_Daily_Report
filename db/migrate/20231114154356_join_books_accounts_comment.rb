class JoinBooksAccountsComment < ActiveRecord::Migration[7.0]
  def change
    create_table :books_comments do |t|
      t.belongs_to :book, null: false, foreign_key: true
      t.belongs_to :account, null: false, foreign_key: true

      t.text :content, null: false
      t.timestamps
    end
    add_index :books_comments, [:book_id, :account_id], unique: true
  end
end

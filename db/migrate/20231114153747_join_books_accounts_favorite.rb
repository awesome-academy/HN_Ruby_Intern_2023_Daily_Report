class JoinBooksAccountsFavorite < ActiveRecord::Migration[7.0]
  def change
    create_table :book_favorites do |t|
      t.belongs_to :book, null: false, foreign_key: true
      t.belongs_to :account, null: false, foreign_key: true
      t.timestamps
    end
    add_index :book_favorites, [:book_id, :account_id], unique: true
  end
end

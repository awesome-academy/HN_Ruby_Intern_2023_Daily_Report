class JoinAuthorsAccountsFollower < ActiveRecord::Migration[7.0]
  def change
    create_table :author_followers do |t|
      t.belongs_to :account, null: false, foreign_key: true
      t.belongs_to :author, null: false, foreign_key: true
      t.timestamps
    end
    add_index :author_followers, [:account_id, :author_id], unique: true
  end
end

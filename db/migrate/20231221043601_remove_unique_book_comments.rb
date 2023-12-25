class RemoveUniqueBookComments < ActiveRecord::Migration[7.0]
  def change
    remove_index :book_comments, [:book_id, :account_id], unique: true
  end
end

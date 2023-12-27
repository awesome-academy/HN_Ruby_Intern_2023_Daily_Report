class RemoveContentFromBookComments < ActiveRecord::Migration[7.0]
  def change
    remove_column :book_comments, :content, :text, null: false
  end
end

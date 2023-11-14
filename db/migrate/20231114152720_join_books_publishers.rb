class JoinBooksPublishers < ActiveRecord::Migration[7.0]
  def change
    add_reference :books, :publisher,
                  foreign_key: true, index: true, null: false
  end
end

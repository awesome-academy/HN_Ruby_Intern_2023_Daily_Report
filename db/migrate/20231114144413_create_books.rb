class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.integer :amount, null: false
      t.date :publish_date, null: false
      t.string :isbn, null: false

      t.timestamps
    end

    add_index :books, :title, unique: true
    add_index :books, :isbn, unique: true
  end
end

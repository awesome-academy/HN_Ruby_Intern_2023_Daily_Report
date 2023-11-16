class CreateAuthors < ActiveRecord::Migration[7.0]
  def change
    create_table :authors do |t|
      t.string :name, null: false
      t.text :about, null: false
      t.string :phone, null: true
      t.string :email, null: true

      t.timestamps
    end
    add_index :authors, :name
  end
end

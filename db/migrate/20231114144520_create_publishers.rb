class CreatePublishers < ActiveRecord::Migration[7.0]
  def change
    create_table :publishers do |t|
      t.string :name, null: false
      t.string :address, null: false
      t.text :about, null: false
      t.string :email, null: true

      t.timestamps
    end
    add_index :publishers, :name
  end
end

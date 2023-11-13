class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.integer :gender
      t.date :dob
      t.string :phone_number
      t.boolean :activated
      t.references :role, null: false, foreign_key: true

      t.timestamps
    end
  end
end

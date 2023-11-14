class CreateUserInfos < ActiveRecord::Migration[7.0]
  def change
    create_table :user_infos do |t|
      t.string :name, null: false
      t.integer :gender, null: false
      t.string :address, null: false
      t.string :phone, null: false
      t.string :citizen_id, null: false
      t.date :dob, null: true

      t.timestamps
    end
    add_index :user_infos, :name
    add_index :user_infos, :citizen_id, unique: true
    add_index :user_infos, :phone
    add_index :user_infos, :address
  end
end

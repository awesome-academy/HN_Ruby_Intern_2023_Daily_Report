class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.string :email, null: false
      t.string :username, null: false
      t.boolean :is_admin, null: false, default: false

      t.timestamps
    end
    add_index :accounts, :username, unique: true
    add_index :accounts, :email, unique: true
  end
end

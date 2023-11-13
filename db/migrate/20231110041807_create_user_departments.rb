class CreateUserDepartments < ActiveRecord::Migration[7.0]
  def change
    create_table :user_departments do |t|
      t.integer :user_id
      t.integer :department_id

      t.timestamps
    end
    add_index :user_departments, :user_id
    add_index :user_departments, :department_id
    add_index :user_departments, [:user_id, :department_id], unique: true
  end
end

class CreateDepartments < ActiveRecord::Migration[7.0]
  def change
    create_table :departments do |t|
      t.string :name
      t.string :parent_path
      t.integer :parent_id

      t.timestamps
    end
  end
end

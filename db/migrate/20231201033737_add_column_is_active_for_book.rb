class AddColumnIsActiveForBook < ActiveRecord::Migration[7.0]
  def change
    add_column :books, :is_active, :boolean, default: true
  end
end

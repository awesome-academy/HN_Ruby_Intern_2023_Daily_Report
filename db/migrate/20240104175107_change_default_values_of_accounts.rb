class ChangeDefaultValuesOfAccounts < ActiveRecord::Migration[7.0]
  def change
    change_column :accounts, :is_active, :boolean, null: false, default: true
    change_column :accounts, :is_activated, :boolean, null: false, default: true
  end
end

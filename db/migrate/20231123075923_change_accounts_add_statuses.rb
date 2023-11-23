class ChangeAccountsAddStatuses < ActiveRecord::Migration[7.0]
  def change
    add_column :accounts, :is_active, :boolean, null: false, default: false
    add_column :accounts, :is_activated, :boolean, null: false, default: false
  end
end

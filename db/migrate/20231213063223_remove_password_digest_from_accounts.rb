class RemovePasswordDigestFromAccounts < ActiveRecord::Migration[7.0]
  def change
    remove_column :accounts, :password_digest, :string, null: false
    remove_column :accounts, :remember_digest, :string, null: true
  end
end

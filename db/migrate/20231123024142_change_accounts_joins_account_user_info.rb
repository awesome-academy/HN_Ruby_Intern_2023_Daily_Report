class ChangeAccountsJoinsAccountUserInfo < ActiveRecord::Migration[7.0]
  def change
    remove_column :accounts, :password, :string
    add_column :accounts, :password_digest, :string, null: false
    add_column :accounts, :remember_digest, :string, null: true
    remove_reference :accounts, :user_info,
                     foreign_key: true, null: false, index: true
    add_reference :user_infos, :account,
                  foreign_key: true, null: false, index: true
  end
end

class JoinAccountsUserInfos < ActiveRecord::Migration[7.0]
  def change
    add_reference :user_infos, :accounts,
                  foreign_key: true, null: true, index: true
  end
end

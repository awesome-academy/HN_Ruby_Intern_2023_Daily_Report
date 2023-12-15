class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.text :content, null: false
      t.boolean :checked, default: false, null: false
      t.string :link, null: true
      t.integer :status, null: false, default: 0
      t.references :account, foreign_key: true, null: true, index: true
      t.timestamps
    end
  end
end

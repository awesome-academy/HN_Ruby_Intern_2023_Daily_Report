class CreateReports < ActiveRecord::Migration[7.0]
  def change
    create_table :reports do |t|
      t.date :report_date
      t.text :today_plan
      t.text :actual_work
      t.text :not_completed
      t.text :tomorrow_plan
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

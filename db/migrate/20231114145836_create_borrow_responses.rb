class CreateBorrowResponses < ActiveRecord::Migration[7.0]
  def change
    create_table :borrow_responses do |t|
      t.text :content

      t.timestamps
    end
  end
end

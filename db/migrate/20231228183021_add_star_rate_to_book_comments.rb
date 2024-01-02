class AddStarRateToBookComments < ActiveRecord::Migration[7.0]
  def change
    add_column :book_comments, :star_rate, :integer, null: false
  end
end

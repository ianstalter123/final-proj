class AddAsinToWatchList < ActiveRecord::Migration
  def change
  	add_column :lists, :asin, :string
  end
end

class AddImageToWatchlist < ActiveRecord::Migration
  def change
  	add_column :lists, :image, :string
  end
end

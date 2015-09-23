class AddEmailToWatchList < ActiveRecord::Migration
  def change
  	add_column :lists, :email, :string
  	add_column :lists, :last_check, :string
  	add_column :lists, :next_check, :string
  	add_column :lists, :last_price, :string
  end
end

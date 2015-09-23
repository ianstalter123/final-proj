class AddItemToLists < ActiveRecord::Migration
  def change
  	add_column :lists, :date, :string
  	add_column :lists, :item, :string
  	add_column :lists, :freq, :string
  end
end

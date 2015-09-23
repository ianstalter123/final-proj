class AddPriceToLists < ActiveRecord::Migration
  def change
  	add_column :lists, :price, :string
  end
end

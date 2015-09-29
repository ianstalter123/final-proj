class AddAvgToLists < ActiveRecord::Migration
  def change
  	add_column :lists, :avg, :string
  end
end

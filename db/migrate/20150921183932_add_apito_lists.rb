class AddApitoLists < ActiveRecord::Migration
  def change
  	add_column :lists, :api, :string
  end
end

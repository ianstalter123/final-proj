class AddListIdtoLprice < ActiveRecord::Migration
  def change
  	add_column :lprices, :list_id, :string
  end
end

class CreateLprices < ActiveRecord::Migration
  def change
    create_table :lprices do |t|
      t.string :date
      t.string :price
      t.timestamps null: false
    end
  end
end

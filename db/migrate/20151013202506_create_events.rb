class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :Title
      t.string :Description
      t.integer :Latitude
      t.integer :Longitude
      t.string :Category
      t.integer :Day
      t.integer :Month
      t.integer :Year

      t.timestamps null: false
    end
  end
end

class ChangeLatLongInEvent < ActiveRecord::Migration
  def self.up
    change_column :events, :Latitude, :decimal, :precision => 6
    change_column :events, :Longitude, :decimal, :precision => 6
  end
  
  def self.down
    change_column :events, :Latitude, :integer
    change_column :events, :Longitude, :integer
  end
end

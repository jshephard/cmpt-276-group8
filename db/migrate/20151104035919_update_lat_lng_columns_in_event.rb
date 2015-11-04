class UpdateLatLngColumnsInEvent < ActiveRecord::Migration
  def change
    change_column :events, :Latitude, :decimal, :precision => 9, :scale => 6
    change_column :events, :Longitude, :decimal, :precision => 9, :scale => 6
  end
end

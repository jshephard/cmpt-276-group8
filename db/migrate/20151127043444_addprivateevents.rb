class Addprivateevents < ActiveRecord::Migration
  def change
    add_column :events, :id_private, :boolean
  end
end

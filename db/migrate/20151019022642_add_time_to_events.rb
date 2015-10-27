class AddTimeToEvents < ActiveRecord::Migration
  def change
    add_column :events, :StartMinute, :integer
    add_column :events, :StartHour, :integer
    add_column :events, :EndMinute, :integer
    add_column :events, :EndHour, :integer
  end
end

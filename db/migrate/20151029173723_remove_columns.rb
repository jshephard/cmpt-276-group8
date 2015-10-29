class RemoveColumns < ActiveRecord::Migration
  def change
    remove_column :events, :StartMinute
    remove_column :events, :StartHour
    remove_column :events, :EndMinute
    remove_column :events, :EndHour
    remove_column :events, :StartDay
    remove_column :events, :StartMonth
    remove_column :events, :StartYear
    remove_column :events, :EndDay
    remove_column :events, :EndMonth
    remove_column :events, :EndYear
    add_column :events, :StartTime, :time
    add_column :events, :EndTime, :time
    add_column :events, :StartDate, :date
    add_column :events, :EndDate, :date
  end
end

class MultiDayEventsUpdate < ActiveRecord::Migration
  def change
    rename_column :events, :Day, :StartDay
    rename_column :events, :Month, :StartMonth
    rename_column :events, :Year, :StartYear
    add_column :events, :EndDay, :integer
    add_column :events, :EndMonth, :integer
    add_column :events, :EndYear, :integer
  end
end

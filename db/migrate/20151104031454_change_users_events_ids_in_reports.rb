class ChangeUsersEventsIdsInReports < ActiveRecord::Migration
  def change
    rename_column :reports, :users_id, :user_id
    rename_column :reports, :events_id, :event_id
  end
end

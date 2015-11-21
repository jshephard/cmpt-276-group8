json.extract! @event, :id, :Title, :Description, :Address, :Latitude, :Longitude,
              :Category, :created_at, :updated_at, :username
if !@event.user_id.nil?
  json.user_url user_url(@event.user_id)
end
json.StartDate @event.StartDate.strftime("%F")
json.StartTime @event.StartTime.strftime("%l:%M %P")
json.EndDate @event.EndDate.strftime("%F")
json.EndTime @event.EndTime.strftime("%l:%M %P")
json.report_url new_event_report_url(@event.id)
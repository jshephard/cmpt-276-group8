json.array!(@events) do |event|
  json.extract! event, :id, :Title, :Description, :Address, :Latitude, :Longitude, :Category, :username
  json.show_url event_url(event)
  json.edit_url edit_event_url(event)
  json.destroy_url event_url(event)
  json.StartDate event.StartDate.strftime("%F")
  json.StartTime event.StartTime.strftime("%l:%M %P")
  json.EndDate event.EndDate.strftime("%F")
  json.EndTime event.EndTime.strftime("%l:%M %P")
  if !event.user_id.nil?
    json.user_url user_url(event.user_id)
  end
end

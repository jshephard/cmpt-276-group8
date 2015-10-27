json.array!(@events) do |event|
  json.extract! event, :id, :Title, :Description, :Address, :Latitude, :Longitude, :Category, :StartDay, :StartMonth,
                :StartYear, :EndDay, :EndMonth, :EndYear, :StartHour, :StartMinute, :EndHour, :EndMinute
  json.show_url event_url(event)
  json.edit_url edit_event_url(event)
  json.destroy_url event_url(event)
end

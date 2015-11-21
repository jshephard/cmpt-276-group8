json.extract! @event, :id, :Title, :Description, :Address, :Latitude, :Longitude,
              :Category, :created_at, :updated_at, :username
json.user_url user_url(@event.user_id)
json.StartDate @event.StartDate.strftime("%F")
json.StartTime @event.StartTime.strftime("%l:%M %P")
json.EndDate @event.EndDate.strftime("%F")
json.EndTime @event.EndTime.strftime("%l:%M %P")
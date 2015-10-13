json.array!(@events) do |event|
  json.extract! event, :id, :Title, :Description, :Latitude, :Longitude, :Category, :Day, :Month, :Year
  json.url event_url(event, format: :json)
end

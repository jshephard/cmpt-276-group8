json.array!(@reports) do |report|
  json.extract! report, :description #, :user_id, :event_id
  user = User.find_by(id: report.user_id)
  event = Event.find_by(id: report.event_id)

  if user.nil?
    json.user "Deleted User"
  else
    json.user user.username
    json.user_url edit_user_url(user)
  end

  if event.nil?
    json.event "Deleted Event"
  else
    json.event event.Title
    json.event_url event_url(event)
    json.event_reports_url event_reports_url(event)
  end
  json.report_url report_url(report)
end

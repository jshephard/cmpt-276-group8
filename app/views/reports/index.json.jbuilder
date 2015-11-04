json.array!(@reports) do |report|
  json.extract! report, :description #, :user_id, :event_id
  user = User.find_by(id: report.user_id)
  event = Event.find_by(id: report.event_id)

  json.user user.username
  json.user_url edit_user_url(user)

  json.event event.Title
  json.event_url event_url(event)
  json.report_url report_url(report)
  json.event_reports_url event_reports_url(event)
end

json.array!(@users) do |user|
  json.extract! user, :username, :first_name, :last_name
  if logged_in? and current_user.is_administrator?
    json.extract! user, :email, :is_administrator?, :is_promoter?
    json.edit_url edit_user_url(user)
  end
  json.user_events_url user_events_url(user)
  json.user_url user_url(user)
end

json.array!(@users) do |user|
  json.extract! user, :username, :email, :first_name, :last_name, :is_administrator?, :is_promoter?
  json.edit_url edit_user_url(user)
end

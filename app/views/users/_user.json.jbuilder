json.extract! user, :id, :active, :fullname, :username, :password, :email, :bio, :homepage, :laconica_profile, :created_at, :updated_at
json.url user_url(user, format: :json)

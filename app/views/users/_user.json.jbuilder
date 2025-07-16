json.extract! user, :id, :name, :age, :phone, :email, :created_at, :updated_at, :age, :phone, :date_of_birth, :gender
json.url user_url(user, format: :json)

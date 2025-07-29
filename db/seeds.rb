# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# db/seeds.rb

User.create!(
  name:  "Example User",
  email: "a@gmail.com",
  password:              "123",
  password_confirmation: "123",
  admin: true,
  activated: true,
  activated_at: Time.zone.now
)

30.times do |n|
  name     = Faker::Name.name
  email    = "example-#{n + 1}@railstutorial.org"
  password = "password"
  User.create!(
    name:  name,
    email: email,
    password:              password,
    password_confirmation: password,
    activated: true,
    activated_at: Time.zone.now
  )
end

users = User.order(:created_at).take(6)
users.each do |user|
  10.times do
    content = Faker::Lorem.sentence(word_count: 5)
    user.microposts.create!(content: content)
  end
end

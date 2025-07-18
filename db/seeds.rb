# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# db/seeds.rb

User.create!(
  name: "Example User",
  email: "example@example.com",
  password: "password",
  password_confirmation: "password",
  age: 25,
  phone: "0123456789",
  date_of_birth: Date.new(2000, 1, 1),
  gender: "male"
)

10.times do |n|
  User.create!(
    name: "User #{n + 1}",
    email: "user#{n + 1}@example.com",
    password: "password",
    password_confirmation: "password",
    age: 20 + n,
    phone: "09876543#{n}",
    date_of_birth: Date.new(2000, (n % 12) + 1, (n % 28) + 1),
    gender: n.even? ? "male" : "female"
  )
end


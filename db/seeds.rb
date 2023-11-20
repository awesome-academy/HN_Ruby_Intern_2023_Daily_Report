# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
Account.create!(
  email: "admin@gmail.com",
  username: "administrator",
  password: "libma-123",
  password_confirmation: "libma-123",
  is_admin: true,
)
Account.create!(
  email: "user001@gmail.com",
  username: Faker::Internet.username,
  password: "111111",
  password_confirmation: "111111",
  is_admin: false,
)

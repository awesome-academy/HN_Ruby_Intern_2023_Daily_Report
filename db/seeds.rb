# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
Account.destroy_all
UserInfo.destroy_all

# Standard Accounts
admin = Account.create!(
  email: "admin@gmail.com",
  username: "administrator",
  password: "libma-123",
  password_confirmation: "libma-123",
  is_admin: true,
  is_activated: true,
  is_active: true,
)
admin.avatar.attach(io: File.open("#{Rails.root}/app/assets/images/admin/face5.jpg"), filename: "admin-face.jpg")

account = Account.create!(
  email: "account01@gmail.com",
  username: Faker::Internet.username,
  password: "111111",
  password_confirmation: "111111",
  is_admin: false,
)

# Fake
10.times do |i|
  if i > 0
    ac = Account.create!(
      email: Faker::Internet.email,
      username: Faker::Internet.username,
      password: "111111",
      password_confirmation: "111111",
      is_admin: false,
      is_activated: true,
      is_active: i % 4 == 0,
    )
  else
    ac = account
  end
  begin
    img = URI.parse(Faker::Avatar.image).open
    ac.avatar.attach(io: img, filename: "user#{i}-avatar.png")
  rescue
  end
  u = UserInfo.create!(
    name: Faker::Name.name,
    gender: rand(3),
    address: Faker::Address.full_address,
    phone: Faker::PhoneNumber.cell_phone,
    citizen_id: Faker::IDNumber.valid,
    dob: Faker::Date.birthday(min_age: 18, max_age: 65),
    account: ac,
  )
end

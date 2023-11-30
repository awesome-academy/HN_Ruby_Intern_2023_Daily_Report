# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# Standard Accounts
admin = Account.create(
  email: "admin@gmail.com",
  username: "administrator",
  password: "libma-123",
  password_confirmation: "libma-123",
  is_admin: true,
  is_activated: true,
  is_active: true,
)
admin.avatar.attach(io: File.open("#{Rails.root}/app/assets/images/admin/face5.jpg"), filename: "admin-face.jpg")

account = Account.create(
  email: "account01@gmail.com",
  username: Faker::Internet.username,
  password: "111111",
  password_confirmation: "111111",
  is_admin: false,
)

# Fake Accounts
10.times do |i|
  if i > 0
    ac = Account.create(
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
    img = URI.parse(Faker::LoremFlickr.image).open
    ac.avatar.attach(io: img, filename: "user#{i}-avatar.png")
  rescue
  end

  u = UserInfo.create(
    name: Faker::Name.name,
    gender: rand(3),
    address: Faker::Address.full_address,
    phone: Faker::PhoneNumber.cell_phone,
    citizen_id: Faker::IDNumber.valid,
    dob: Faker::Date.birthday(min_age: 18, max_age: 65),
    account: ac,
  )
end

# Publisher
30.times do |n|
  name = Faker::Book.unique.publisher
  address = Faker::Address.full_address
  about = "#{name} #{Faker::Lorem.paragraph}"
  email = Faker::Internet.email(name: name)

  Publisher.create(
    name: name,
    address: address,
    about: about,
    email: email,
  )
end

# Author
100.times do |n|
  name = Faker::Name.name
  about = "#{name} #{Faker::Lorem.paragraph}"
  phone = Faker::PhoneNumber.cell_phone
  email = Faker::Internet.email(name: name)

  Author.create(name:, about:, phone:, email:)
end

# Genre
7.times do |n|
  name = Faker::Book.genre
  description = "#{name} #{Faker::Lorem.paragraph}"

  Genre.create(name:, description:)
end

# Book
180.times do |n|
  title = Faker::Book.title
  while Book.exists?(title: title)
    title = Faker::Book.title
  end
  description = "#{title} Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
  amount = rand(1..100)
  publish_date = Faker::Date.backward
  isbn = Faker::Code.unique.isbn(base: (rand % 2 == 1 ? 13 : 10))
  publisher_id = Publisher.pluck(:id).sample

  Book.create(
    title: title,
    description: description,
    amount: amount,
    publish_date: publish_date,
    isbn: isbn,
    publisher_id: publisher_id
  )
end

Book.all.each do |book|
  file_path = URI.parse(Faker::LoremFlickr.image(size: "200x250")).open
  book.image.attach(io: file_path, filename: "image.jpg")
end

# Create fake associations for books
Book.all.each do |book|
  book_id = book.id
  author_id = Author.pluck(:id).sample
  genre_id = Genre.pluck(:id).sample

  BookAuthor.create!(
    book_id: book_id,
    author_id: author_id,
  )

  BookGenre.create!(
    book_id: book_id,
    genre_id: genre_id,
  )
end

30.times do |n|
  name = Faker::Book.unique.genre
  description = "#{name} #{Faker::Lorem.paragraph}"

  Genre.create!(
    name: name,
    description: description,
  )

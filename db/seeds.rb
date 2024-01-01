# Admin
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

# Test account
account = Account.create(
  email: "test@gmail.com",
  username: Faker::Internet.username,
  password: "111111",
  password_confirmation: "111111",
  is_admin: false,
  is_activated: true,
  is_active: true,
)

# Fake Accounts
10.times do |i|
  Account.create(
    email: Faker::Internet.email,
    username: Faker::Internet.username,
    password: "111111",
    password_confirmation: "111111",
    is_admin: false,
    is_activated: true,
    is_active: i % 4 == 0,
  )
end

Account.where(is_admin: false).each do |ac|
  img = URI.parse(Faker::LoremFlickr.image).open
  ac.avatar.attach(io: img, filename: "user-avatar.png")

  UserInfo.new(
    name: Faker::Name.name,
    gender: rand(3),
    address: Faker::Address.full_address,
    phone: Faker::PhoneNumber.cell_phone,
    citizen_id: Faker::IDNumber.valid,
    dob: Faker::Date.birthday(min_age: 18, max_age: 65),
    account: ac,
  ).save(validate: false)
end

# Publisher
15.times do |n|
  name = Faker::Book.unique.publisher
  address = Faker::Address.full_address
  about = "#{name} #{Faker::Lorem.paragraph}"
  email = Faker::Internet.email(name: name)

  Publisher.create(name:, address:, about:, email:)
end

# Author
50.times do |n|
  name = Faker::Name.name
  about = "#{name} #{Faker::Lorem.paragraph}"
  phone = Faker::PhoneNumber.cell_phone
  email = Faker::Internet.email(name: name)

  Author.create(name:, about:, phone:, email:)
end

Author.all.each do |author|
  file_path = URI.parse(Faker::LoremFlickr.image(size: "200x250")).open
  author.avatar.attach(io: file_path, filename: "#{author.name}-avatar.png")
end

# Book
100.times do |n|
  title = Faker::Book.title
  while Book.exists?(title: title)
    title = Faker::Book.title
  end
  description = "#{title} Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
  amount = rand(1..100)
  borrowed_count = 0
  publish_date = Faker::Date.backward
  isbn = Faker::Code.unique.isbn(base: (rand % 2 == 1 ? 13 : 10))
  publisher_id = Publisher.pluck(:id).sample

  Book.create(title:, description:, amount:, publish_date:, isbn:, publisher_id:, borrowed_count:)
end

Book.all.each do |book|
  file_path = URI.parse(Faker::LoremFlickr.image(size: "200x250")).open
  book.image.attach(io: file_path, filename: "image.jpg")
end

# Genre
30.times do |n|
  name = Faker::Book.unique.genre
  description = "#{name} #{Faker::Lorem.paragraph}"

  Genre.create!(name:, description:)
end

# Create fake associations for books
Book.pluck(:id).each do |book_id|
  author_ids = Author.pluck(:id).sample(rand(1..3))
  genre_ids = Genre.pluck(:id).sample(rand(1..3))

  author_ids.each do |author_id|
    BookAuthor.create book_id:, author_id:
  end

  genre_ids.each do |genre_id|
    BookGenre.create book_id:, genre_id:
  end
end

100.times do |i|
  b = BorrowInfo.create(
    start_at: Date.current + 3,
    end_at: Date.current + 10,
    status: rand(5),
    turns: rand(5),
    account_id: Account.pluck(:id).sample
  )
end

BorrowInfo.pluck(:id).each do |borrow_info_id|
  book_ids = Book.pluck(:id).sample(rand(1..7))

  book_ids.each do |book_id|
    BorrowItem.create(borrow_info_id:, book_id:)
  end
end

BorrowInfo.rejected.each do |rej|
  BorrowResponse.create(
    content: Faker::Lorem.paragraph,
    borrow_info_id: rej.id
  )
end

Book.all.each do |book|
  book.update borrowed_count: BorrowItem.where(book_id: book.id).count
end

# Notification for one user
30.times do |i|
  Notification.create(
    content: Faker::Lorem.paragraph,
    account_id: Account.pluck(:id).sample,
    checked: rand(3) == 1,
    status: rand(3)
  )
end

# Notification for all user (except admin)
10.times do |i|
  Notification.create(
    content: Faker::Lorem.paragraph,
    account_id: nil,
    checked: rand(3) == 1,
    status: rand(3)
  )
end

# Notification for except admin
10.times do |i|
  Notification.create(
    content: Faker::Lorem.paragraph,
    account_id: 1,
    checked: rand(3) == 1,
    status: rand(3)
  )
end

BorrowItem.all.each do |borrow|
  borrow.update_attribute :created_at, Faker::Time.backward(days: 40)
end

BorrowInfo.all.each do |borrow|
  borrow.update_attribute :start_at, Faker::Date.backward(days: 700)
  borrow.update_attribute :created_at, borrow.start_at
  borrow.update_attribute :end_at, borrow.start_at + rand(30)
  borrow.update_attribute :updated_at, borrow.end_at + rand(13)
end

BorrowItem.all.each do |borrow|
  borrow.update_attribute :created_at, Faker::Date.backward(days: 400)
  # borrow.update_attribute :end_at, borrow.start_at + rand(30)
  borrow.update_attribute :updated_at, borrow.created_at
end

# BookComment
Book.all.each do |book|
  5.times do
    BookComment.create!(
      book_id: book.id,
      account_id: 1,
      star_rate: rand(1..5),
      content: Faker::Lorem.sentence(word_count: 10)
    )
  end
end

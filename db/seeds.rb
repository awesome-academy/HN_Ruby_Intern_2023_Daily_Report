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
admin.avatar.attach(io: File.open("#{Rails.root}/app/assets/images/admin/admin-avatar.jpg"), filename: "admin-avatar.jpg")

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
35.times do |i|
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

Account.not_admin.each do |ac|
  img = URI.parse(Faker::LoremFlickr.image).open
  ac.avatar.attach(io: img, filename: "user-avatar.png")

  UserInfo.create(
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
15.times do |n|
  name = Faker::Book.unique.publisher
  address = Faker::Address.full_address
  about = "#{name} #{Faker::Lorem.paragraph}"
  email = Faker::Internet.email

  Publisher.create(name:, address:, about:, email:)
end

# Author
30.times do |n|
  name = Faker::Name.name
  about = "#{name} #{Faker::Lorem.paragraph}"
  phone = Faker::PhoneNumber.cell_phone
  email = Faker::Internet.email

  Author.create(name:, about:, phone:, email:)
end

Author.all.each do |author|
  file_path = URI.parse(Faker::LoremFlickr.image(size: "200x250")).open
  author.avatar.attach(io: file_path, filename: "#{author.name}-avatar.png")
end

# Genre
30.times do |n|
  name = Faker::Book.unique.genre
  description = "#{name} #{Faker::Lorem.paragraph(sentence_count: 5)}"

  Genre.create(name:, description:) do
end

# Book
100.times do |n|
  title = Faker::Book.unique.title
  description = "#{title} #{Faker::Lorem.paragraph(sentence_count: 10)}"
  amount = rand(1..100)
  borrowed_count = 0
  publish_date = Faker::Date.backward
  isbn = Faker::Code.unique.isbn(base: (rand % 2 == 1 ? 13 : 10)).gsub("X", "0")

  publisher_id = Publisher.pluck(:id).sample

  Book.create(title:, description:, amount:, publish_date:, isbn:, publisher_id:, borrowed_count:)
end

Book.all.each do |book|
  file_path = URI.parse(Faker::LoremFlickr.image(size: "200x250")).open
  book.image.attach(io: file_path, filename: "image.jpg")
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

# BorrowInfo
200.times do |i|
  start_at = Faker::Date.between(from: 2.years.ago, to: 7.days.after)
  status = rand(6)
  BorrowInfo.new(
    start_at:,
    end_at: start_at + rand(3..10),
    status:,
    turns: status == 0 ? 0 : rand(5),
    account_id: i % 5 == 0 ? 2 : Account.not_admin.pluck(:id).sample
  ).save(validate: false)
end

BorrowInfo.pluck(:id).each do |borrow_info_id|
  book_ids = Book.limit(30).pluck(:id).sample(rand(1..7))

  book_ids.each do |book_id|
    BorrowItem.create(borrow_info_id:, book_id:)
  end
end

BorrowItem.all.each do |item|
  created = item.borrow_info.created_at
  item.update created_at: created, updated_at: created
end

BorrowInfo.rejected.each do |borrow|
  BorrowResponse.create(
    content: Faker::Lorem.paragraph,
    borrow_info_id: borrow.id
  )
end

BorrowInfo.returned.each do |borrow|
  borrow.update done_at: (borrow.start_at + rand(2..20))
end

BorrowInfo.canceled.each do |borrow|
  borrow.update done_at: (borrow.start_at + rand(5..7))
end

BorrowInfo.renewing.each do |borrow|
  borrow.update renewal_at: (borrow.end_at + rand(3..10))
  borrow.update turns: rand(1..5)
end

Book.all.each do |book|
  borrowed_count = BorrowItem.where(book_id: book.id).count
  if borrowed_count >= book.amount
    book.update! amount: borrowed_count
  end
  book.update! borrowed_count:
end

# BookComment
Book.all.each do |book|
  5.times do
    BookComment.create(
      book_id: book.id,
      account_id: Account.not_admin.pluck(:id).sample,
      star_rate: rand(1..5),
      content: Faker::Lorem.sentence(word_count: 10)
    )
  end
end

# Notifications
BorrowInfo.approved.or(BorrowInfo.rejected).each do |borrow|
  borrow.account.notification_for_me :info,
                                     "notifications.borrow_#{borrow.status}",
                                     link: Rails.application.routes.url_helpers.borrow_info_path(id: borrow.id)
end

BorrowInfo.returned.each do |borrow|
  return unless borrow.overdue?
  borrow.account.notification_for_me :notice,
                                     "notifications.borrow_returned_overdue",
                                     link: Rails.application.routes.url_helpers.borrow_info_path(id: borrow.id)
end

10.times do |i|
  notif = Account.only_admin.first.notification_for_me :info, I18n.t("admin.notif.report_sent")
  notif.update_attribute :created_at, Faker::Date.backward
end


def fake_created_at klass
  klass.all.each do |obj|
    obj.update_column :created_at, Faker::Date.backward(days: 365)
  end
end

fake_created_at Book
fake_created_at Author
fake_created_at Genre
fake_created_at UserInfo
fake_created_at Publisher
fake_created_at BorrowInfo

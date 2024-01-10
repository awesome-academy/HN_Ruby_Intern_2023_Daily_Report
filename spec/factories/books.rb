FactoryBot.define do
  factory :book do
    title { Faker::Book.unique.title }
    description { Faker::Lorem.paragraph }
    amount { 10 }
    publish_date { 4.months.ago }
    isbn { Faker::Code.unique.isbn(base: (rand % 2 == 1 ? 13 : 10)).gsub("X", "0") }
  end
end

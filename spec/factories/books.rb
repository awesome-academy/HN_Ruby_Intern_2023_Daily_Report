FactoryBot.define do
  factory :book do
    title { Faker::Book.unique.title }
    description { "desc" }
    amount { 10 }
    isbn { "1234567890" }
    publish_date { "2021-07-01" }
  end
end

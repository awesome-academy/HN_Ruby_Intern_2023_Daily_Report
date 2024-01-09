FactoryBot.define do
  factory :book do
    sequence(:title, "aaa"){|n| "#{Faker::Book.title}-#{n}"}
    description{Faker::Lorem.paragraph}
    amount{rand(30..100)}
    publish_date{Faker::Date.backward}
    sequence(:isbn, "0000"){|n| "123321-#{n}"}
    publisher

    factory :book_full_info do
      after(:create) do |book, evaluator|
        create_list(:author, 1, books: [book])
        create_list(:genre, 1, books: [book])
        book.reload
      end
    end

    trait :borrowable_book do
      borrowed_count{1}
    end

    trait :non_borrowable_book do
      borrowed_count{amount}
    end
  end
end

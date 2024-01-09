FactoryBot.define do
  factory :borrow_info do
    start_at{Faker::Date.forward(days: 5)}
    end_at{start_at + rand(3..10)}
    sequence(:status, (0..5).to_a.cycle){|n| n}
    turns{status == 0 ? 0 : rand(5)}
    renewal_at{(end_at + rand(3..10)) if status == 5}
    account

    transient do
      borrowable{true}
    end

    after(:create) do |borrow, evaluator|
      book_type = evaluator.borrowable ? :borrowable_book : :non_borrowable_book
      create_list(:book, 1, book_type, borrow_requests: [borrow])

      borrow.reload
    end
  end
end

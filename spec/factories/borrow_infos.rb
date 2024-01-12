FactoryBot.define do
  factory :borrow_info do
    start_at { Date.current + 2 }
    end_at { Date.current + 10 }
  end
end

FactoryBot.define do
  factory :account do
    sequence(:email){|n| "user+#{n}@example.com"}
    sequence(:username, 'a'){|n| "hello-world-#{n}"}
    password{"111111"}
    is_activated{true}
    is_active{true}

    factory :admin do
      is_admin{true}
      username{"administrator"}
    end

    factory :inactive_account do
      is_active{false}
    end

    factory :not_activated_account do
      is_active{false}
      is_activated{false}
    end
  end
end

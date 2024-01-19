FactoryBot.define do
  factory :account do
    sequence(:email, "aaa"){|n| "user+#{n}@example.com"}
    sequence(:username, "aaa"){|n| "hello-world-#{n}"}
    password{"111111"}
    password_confirmation{"111111"}
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

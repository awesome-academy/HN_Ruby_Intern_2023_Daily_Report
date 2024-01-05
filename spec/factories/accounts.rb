FactoryBot.define do
  factory :account do
    email { "account@gmail.com" }
    password { "123456" }
    username { "account" }
  end
end

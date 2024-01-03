FactoryBot.define do
  factory :account do
    id { 1 }
    email { "example@gmail.com" }
    password { "password" }
    username { "example" }
  end
end

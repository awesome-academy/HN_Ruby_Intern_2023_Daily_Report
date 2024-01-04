FactoryBot.define do
  factory :author do
    name { "Test Author" }
    about { "Test Author About" }
    phone { "0123456789" }
    email { "author@gmail.com" }
  end
end

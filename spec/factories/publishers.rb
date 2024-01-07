FactoryBot.define do
  factory :publisher do
    name { "John" }
    email { "john@example.com" }
    address { "123 Street" }
    about { "About John" }
  end
end

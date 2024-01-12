FactoryBot.define do
  factory :genre do
    sequence(:name, "aaa"){|n| "genre-#{n}"}
    description{Faker::Lorem.paragraph}
  end
end

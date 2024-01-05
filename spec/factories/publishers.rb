FactoryBot.define do
  factory :publisher do
    sequence(:name, "aaa"){|n| "#{Faker::Book.publisher}-#{n}"}
    address{Faker::Address.full_address}
    about{Faker::Lorem.paragraph}
  end
end

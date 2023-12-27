FactoryBot.define do
  factory :user_info do
    name{"Gilberto Bernhard"}
    gender{:male}
    address{"Suite 301 84130 Hills Groves, Simonisborough, NM 23707"}
    phone{"3950542520"}
    dob{23.years.ago}
    sequence(:citizen_id, '00'){|n| "857-90-86#{n}"}
    account
  end
end

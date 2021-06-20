FactoryBot.define do
  factory :dot do
    title { Faker::Lorem.sentence }
    category_id { 1 }
    content { Faker::Lorem.sentence }
    association :user
  end
end

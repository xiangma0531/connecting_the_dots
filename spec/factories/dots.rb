FactoryBot.define do
  factory :dot do
    title { "テスト" }
    category_id { 1 }
    content { Faker::Lorem.sentence }
    association :user
  end
end

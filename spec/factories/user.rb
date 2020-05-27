FactoryBot.define do
  factory :user do
    id { :id }
    sequence(:email) { |n| "user#{n}@example.com" }
    sequence(:password) { |n| "user#{n}11" }
    post
  end
end
FactoryBot.define do
  factory :post do
    sequence(:content) { |n| "somecontent#{n}" }
  end
end

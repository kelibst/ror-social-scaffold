FactoryBot.define do
  factory :post do
    sequence(:content) { |n| "somecontent#{n}" }
  end
end

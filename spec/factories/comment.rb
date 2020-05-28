FactoryBot.define do
  factory :comment do
    sequence(:content) { |n| "somecontent#{n}" }
    post
    user
  end
end

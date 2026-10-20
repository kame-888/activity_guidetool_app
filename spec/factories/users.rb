FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    first_name { "太郎" }
    last_name { "山田" }
    password { "password" }
    role { :guide }

    trait :manager do
      role { :manager }
    end
  end
end
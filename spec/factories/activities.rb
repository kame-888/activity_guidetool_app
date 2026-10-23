FactoryBot.define do
  factory :activity do
    sequence(:title) { |n| "アクティビティ#{n}" }
    genre { :outdoor }
    duration_minutes { 90 }
  end
end

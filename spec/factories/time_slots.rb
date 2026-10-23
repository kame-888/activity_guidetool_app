FactoryBot.define do
  factory :time_slot do
    activity
    starts_at { Time.zone.local(2026, 11, 1, 10, 0) }
    status { :scheduled }
  end
end

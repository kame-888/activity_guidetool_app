FactoryBot.define do
  factory :participant do
    time_slot
    name { "田中 花子" }
    age { 30 }
    caution_category { :none }
  end
end
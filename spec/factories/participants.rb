FactoryBot.define do
  factory :participant do
    time_slot { nil }
    name { "MyString" }
    age { 1 }
    caution_category { 1 }
    caution_detail { "MyText" }
  end
end

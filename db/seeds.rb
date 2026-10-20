Faker::Config.locale = :ja

Favorite.destroy_all
Participant.destroy_all
TimeSlot.destroy_all
Activity.destroy_all

# --- デモ用ユーザー ---
manager = User.find_or_initialize_by(email: "manager@example.com")
manager.assign_attributes(
  first_name: "太郎", last_name: "管理",
  role: :manager, password: "password", password_confirmation: "password"
)
manager.save!

guide = User.find_or_initialize_by(email: "guide@example.com")
guide.assign_attributes(
  first_name: "花子", last_name: "案内",
  role: :guide, password: "password", password_confirmation: "password"
)
guide.save!

# --- アクティビティ ---
activities_data = [
  { title: "シーカヤック体験",   genre: :outdoor, duration_minutes: 90 },
  { title: "森のトレッキング",   genre: :outdoor, duration_minutes: 120 },
  { title: "星空観察ツアー",     genre: :outdoor, duration_minutes: 60 },
  { title: "ガラス細工体験",     genre: :craft,   duration_minutes: 60 },
  { title: "陶芸体験",           genre: :craft,   duration_minutes: 90 },
  { title: "キャンドル作り",     genre: :craft,   duration_minutes: 45 }
]

activities = activities_data.map { |attrs| Activity.create!(attrs) }

# --- 開催枠(今日から7日分、午前・午後の2枠) ---
caution_samples = {
  allergy:  [ "えびアレルギー", "卵アレルギー", "そばアレルギー", "ナッツ類のアレルギー" ],
  medical:  [ "喘息の持病あり", "心臓に持病あり(医師の許可済み)", "高所が苦手" ],
  mobility: [ "膝に不安があり長距離歩行は避けたい", "階段の昇り降りに配慮が必要" ],
  other:    [ "日本語が不慣れ(英語対応希望)", "小さなお子様連れ" ]
}

today = Time.zone.now.beginning_of_day

activities.each do |activity|
  7.times do |day|
    [ 9, 13 ].each do |hour|
      slot = activity.time_slots.create!(
        starts_at: today + day.days + hour.hours,
        status: :scheduled
      )

      # 参加者(1行=1人)を2〜6人
      rand(2..6).times do
        category = :none
        detail = nil

        if rand < 0.25
          category = caution_samples.keys.sample
          detail = caution_samples[category].sample
        end

        slot.participants.create!(
          name: "#{Faker::Name.last_name} #{Faker::Name.first_name}",
          age: rand(4..65),
          caution_category: category,
          caution_detail: detail
        )
      end
    end
  end
end

# 中止の例を1件(天候不良を想定)
TimeSlot.order(:starts_at).last.update!(status: :cancelled, memo: "強風のため中止")

# お気に入りの例
Favorite.create!(user: guide, activity: activities.first)
Favorite.create!(user: guide, activity: activities.third)

puts "ユーザー#{User.count}件 / アクティビティ#{Activity.count}件 / " \
     "開催枠#{TimeSlot.count}件 / 参加者#{Participant.count}件"

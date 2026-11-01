require "rails_helper"

RSpec.describe TimeSlot, type: :model do
  describe "終了時刻" do
    it "未入力なら、アクティビティの所要時間から自動計算される" do
      activity = create(:activity, duration_minutes: 90)
      slot = build(:time_slot, activity: activity, ends_at: nil)

      slot.valid?

      expect(slot.ends_at).to eq slot.starts_at + 90.minutes
    end

    it "開始時刻より前だと無効になる" do
      slot = build(:time_slot, ends_at: Time.zone.local(2026, 11, 1, 9, 0))

      expect(slot).not_to be_valid
      expect(slot.errors[:ends_at]).to be_present
    end
  end

  it { is_expected.to validate_presence_of(:starts_at) }

  describe ".with_caution" do
    it "注意事項のある参加者がいる開催枠だけを返す" do
      caution_slot = create(:time_slot)
      create(:participant, time_slot: caution_slot, caution_category: :allergy, caution_detail: "卵")
      create(:participant, time_slot: caution_slot)
      normal_slot = create(:time_slot)
      create(:participant, time_slot: normal_slot)
      create(:time_slot) # 参加者なし

      expect(TimeSlot.with_caution).to contain_exactly(caution_slot)
    end
  end
end

RSpec.describe TimeSlot, "担当ガイド", type: :model do
  it "未割り当てでも保存できる" do
    expect(build(:time_slot, guide: nil)).to be_valid
  end

  it "ガイドを割り当てられる" do
    expect(build(:time_slot, guide: create(:user, role: :guide))).to be_valid
  end

  it "管理者は担当ガイドにできない" do
    slot = build(:time_slot, guide: create(:user, :manager))

    expect(slot).not_to be_valid
    expect(slot.errors[:guide]).to be_present
  end
end

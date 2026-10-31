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

  describe "担当ガイド" do
    it "ガイド以外のユーザーは割り当てられない" do
      slot = build(:time_slot, guide: create(:user, :manager))

      expect(slot).not_to be_valid
      expect(slot.errors[:guide]).to be_present
    end

    it "未割り当てでも有効" do
      expect(build(:time_slot, guide: nil)).to be_valid
    end
  end

  it { is_expected.to validate_presence_of(:starts_at) }
end

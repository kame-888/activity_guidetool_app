require "rails_helper"

RSpec.describe Activity, type: :model do
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_numericality_of(:duration_minutes).only_integer.is_greater_than(0) }

  describe "#guides" do
    it "開催枠に割り当てられたガイドを重複なく返す" do
      guide = create(:user, role: :guide)
      activity = create(:activity)
      create(:time_slot, activity: activity, guide: guide)
      create(:time_slot, activity: activity, guide: guide, starts_at: Time.zone.local(2026, 11, 2, 10, 0))
      create(:time_slot, activity: activity, guide: nil)

      expect(activity.guides).to contain_exactly(guide)
    end
  end
end

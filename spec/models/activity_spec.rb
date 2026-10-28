require "rails_helper"

RSpec.describe Activity, type: :model do
  describe "担当ガイド" do
    it "未割り当てでも保存できる" do
      expect(build(:activity, guide: nil)).to be_valid
    end

    it "ガイドを割り当てられる" do
      expect(build(:activity, guide: create(:user, role: :guide))).to be_valid
    end

    it "管理者は担当ガイドにできない" do
      activity = build(:activity, guide: create(:user, :manager))

      expect(activity).not_to be_valid
      expect(activity.errors[:guide]).to be_present
    end
  end
end

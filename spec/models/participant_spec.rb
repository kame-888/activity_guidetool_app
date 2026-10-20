require "rails_helper"

RSpec.describe Participant, type: :model do
  it { is_expected.to validate_presence_of(:name) }

  describe "注意事項" do
    it "種類が「なし」なら、内容は空でも有効" do
      participant = build(:participant, caution_category: :none, caution_detail: nil)

      expect(participant).to be_valid
    end

    it "種類を選んだら、内容が必須になる" do
      participant = build(:participant, caution_category: :allergy, caution_detail: nil)

      expect(participant).not_to be_valid
      expect(participant.errors[:caution_detail]).to be_present
    end

    it "caution? は、種類が「なし」以外のとき true になる" do
      expect(build(:participant, caution_category: :none).caution?).to be false
      expect(build(:participant, caution_category: :allergy, caution_detail: "えび").caution?).to be true
    end
  end
end
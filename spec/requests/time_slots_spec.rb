require "rails_helper"

RSpec.describe "TimeSlots assignment", type: :request do
  let(:guide) { create(:user) }
  let(:slot) { create(:time_slot) }

  it "manager は開催枠に担当ガイドを割り当てられる" do
    sign_in create(:user, :manager)

    patch activity_time_slot_path(slot.activity, slot), params: { time_slot: { guide_id: guide.id } }

    expect(slot.reload.guide).to eq guide
  end

  it "guide は担当ガイドを変更できない" do
    sign_in guide

    patch activity_time_slot_path(slot.activity, slot), params: { time_slot: { guide_id: guide.id } }

    expect(slot.reload.guide).to be_nil
    expect(response).to redirect_to(root_path)
  end
end

RSpec.describe "TimeSlots mine", type: :request do
  it "自分が担当する今日以降の開催枠だけが表示される" do
    me = create(:user)
    other = create(:user)
    create(:time_slot, activity: create(:activity, title: "自分の担当枠"), guide: me,
                       starts_at: 1.day.from_now)
    create(:time_slot, activity: create(:activity, title: "他人の担当枠"), guide: other,
                       starts_at: 1.day.from_now)
    create(:time_slot, activity: create(:activity, title: "終わった担当枠"), guide: me,
                       starts_at: 2.days.ago)
    sign_in me

    get mine_time_slots_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("自分の担当枠")
    expect(response.body).not_to include("他人の担当枠")
    expect(response.body).not_to include("終わった担当枠")
  end
end

require "rails_helper"

RSpec.describe "Activities", type: :request do
  describe "POST /activities" do
    let(:params) { { activity: { title: "新規", genre: "outdoor", duration_minutes: 60 } } }

    it "guide は作成できず、一覧に戻される" do
      sign_in create(:user, role: :guide)

      expect { post activities_path, params: params }.not_to change(Activity, :count)
      expect(response).to redirect_to(root_path)
    end

    it "manager は作成できる" do
      sign_in create(:user, :manager)

      expect { post activities_path, params: params }.to change(Activity, :count).by(1)
    end
  end

  describe "GET /activities/:id" do
    it "開催枠ごとの担当ガイドを表示する" do
      guide = create(:user, last_name: "佐藤", first_name: "花子")
      slot = create(:time_slot, guide: guide)
      sign_in guide

      get activity_path(slot.activity)

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("佐藤 花子")
    end
  end
end

RSpec.describe "Activities search", type: :request do
  it "開催枠の担当ガイドで絞り込める" do
    guide_a = create(:user, last_name: "佐藤")
    guide_b = create(:user, last_name: "鈴木")
    create(:time_slot, activity: create(:activity, title: "佐藤さんの担当"), guide: guide_a)
    create(:time_slot, activity: create(:activity, title: "鈴木さんの担当"), guide: guide_b)
    sign_in guide_a

    get activities_path, params: { q: { time_slots_guide_id_eq: guide_a.id } }

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("佐藤さんの担当")
    expect(response.body).not_to include("鈴木さんの担当")
  end
end

RSpec.describe "TimeSlots assignment", type: :request do
  it "manager は開催枠に担当ガイドを割り当てられる" do
    guide = create(:user)
    slot = create(:time_slot)
    sign_in create(:user, :manager)

    patch activity_time_slot_path(slot.activity, slot), params: { time_slot: { guide_id: guide.id } }

    expect(slot.reload.guide).to eq guide
  end
end

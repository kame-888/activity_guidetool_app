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
end

RSpec.describe "Activities search", type: :request do
  it "開催枠の担当ガイドで絞り込める" do
    guide_a = create(:user, last_name: "佐藤")
    guide_b = create(:user, last_name: "鈴木")
    create(:time_slot, activity: create(:activity, title: "佐藤さんの担当"), guide: guide_a)
    create(:time_slot, activity: create(:activity, title: "鈴木さんの担当"), guide: guide_b)
    sign_in guide_a

    get activities_path, params: { q: { time_slots_guide_id_eq: guide_a.id } }

    expect(response.body).to include("佐藤さんの担当")
    expect(response.body).not_to include("鈴木さんの担当")
  end
end

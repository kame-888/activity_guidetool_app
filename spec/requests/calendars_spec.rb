require "rails_helper"

RSpec.describe "Calendars", type: :request do
  let(:user) { create(:user) }

  before { sign_in user }

  describe "GET /calendar" do
    it "指定月の開催枠を表示し、注意事項のある枠を色分けする" do
      caution_activity = create(:activity, title: "注意ありツアー")
      caution_slot = create(:time_slot, activity: caution_activity, starts_at: Time.zone.local(2026, 11, 3, 10, 0))
      create(:participant, time_slot: caution_slot, caution_category: :medical, caution_detail: "喘息")

      normal_activity = create(:activity, title: "通常ツアー")
      create(:time_slot, activity: normal_activity, starts_at: Time.zone.local(2026, 11, 5, 10, 0))

      cancelled_activity = create(:activity, title: "中止ツアー")
      create(:time_slot, activity: cancelled_activity, status: :cancelled, starts_at: Time.zone.local(2026, 11, 7, 10, 0))

      get calendar_path, params: { month: "2026-11" }

      expect(response).to have_http_status(:ok)
      html = Nokogiri::HTML(response.body)
      expect(html.at_css(".calendar .calendar-slot--caution").text).to include("注意ありツアー")
      expect(html.at_css(".calendar .calendar-slot--normal").text).to include("通常ツアー")
      expect(html.at_css(".calendar .calendar-slot--cancelled").text).to include("中止ツアー")
    end

    it "他の月の開催枠は表示しない" do
      create(:time_slot, activity: create(:activity, title: "来年のツアー"), starts_at: Time.zone.local(2027, 3, 1, 10, 0))

      get calendar_path, params: { month: "2026-11" }

      expect(Nokogiri::HTML(response.body).css(".calendar-slot")).to be_empty
    end

    it "アクティビティで絞り込める" do
      target = create(:activity, title: "対象ツアー")
      other = create(:activity, title: "対象外ツアー")
      create(:time_slot, activity: target)
      create(:time_slot, activity: other)

      get calendar_path, params: { month: "2026-11", activity_id: target.id }

      slots = Nokogiri::HTML(response.body).css(".calendar .calendar-slot").map(&:text).join
      expect(slots).to include("対象ツアー")
      expect(slots).not_to include("対象外ツアー")
    end

    it "不正な月指定でもエラーにならない" do
      get calendar_path, params: { month: "invalid" }

      expect(response).to have_http_status(:ok)
    end
  end
end

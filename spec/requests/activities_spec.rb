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

require "rails_helper"

RSpec.describe Favorite, type: :model do
  it "同じユーザーが同じアクティビティを2回登録できない" do
    user = create(:user)
    activity = create(:activity)
    Favorite.create!(user: user, activity: activity)

    duplicate = Favorite.new(user: user, activity: activity)

    expect(duplicate).not_to be_valid
  end
end
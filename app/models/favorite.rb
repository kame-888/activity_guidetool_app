class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :activity

  validates :activity_id, uniqueness: { scope: :user_id }
end

class Activity < ApplicationRecord
  enum :genre, { outdoor: 0, craft: 1 }

  belongs_to :guide, class_name: "User", optional: true
  has_many :time_slots, dependent: :restrict_with_error
  has_many :favorites, dependent: :destroy

  validates :title, presence: true
  validates :duration_minutes, numericality: { only_integer: true, greater_than: 0 }
  validate :guide_must_have_guide_role

  private

  def guide_must_have_guide_role
    return if guide.blank? || guide.guide?

    errors.add(:guide, "にはガイドのユーザーを選択してください")
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[title genre guide_id]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[time_slots]
  end
end

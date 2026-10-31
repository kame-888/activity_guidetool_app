class TimeSlot < ApplicationRecord
  enum :status, { scheduled: 0, cancelled: 1 }

  belongs_to :activity
  belongs_to :guide, class_name: "User", optional: true
  has_many :participants, dependent: :destroy

  scope :upcoming, -> { where(starts_at: Time.zone.now.beginning_of_day..) }

  before_validation :set_default_ends_at

  validates :starts_at, :ends_at, presence: true
  validate :ends_at_after_starts_at
  validate :guide_must_have_guide_role

  private

  def set_default_ends_at
    return if ends_at.present? || starts_at.blank? || activity.blank?

    self.ends_at = starts_at + activity.duration_minutes.minutes
  end

  def ends_at_after_starts_at
    return if starts_at.blank? || ends_at.blank?

    errors.add(:ends_at, "は開始時刻より後にしてください") if ends_at <= starts_at
  end

  def guide_must_have_guide_role
    return if guide.blank? || guide.guide?

    errors.add(:guide, "にはガイドのユーザーを選択してください")
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[starts_at status guide_id]
  end
end

class TimeSlot < ApplicationRecord
  enum :status, { scheduled: 0, cancelled: 1 }

  belongs_to :activity
  has_many :participants, dependent: :destroy

  before_validation :set_default_ends_at

  validates :starts_at, :ends_at, presence: true
  validate :ends_at_after_starts_at

  private

  def set_default_ends_at
    return if ends_at.present? || starts_at.blank? || activity.blank?

    self.ends_at = starts_at + activity.duration_minutes.minutes
  end

  def ends_at_after_starts_at
    return if starts_at.blank? || ends_at.blank?

    errors.add(:ends_at, "は開始時刻より後にしてください") if ends_at <= starts_at
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[starts_at status]
  end
end
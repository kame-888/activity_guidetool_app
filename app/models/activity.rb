class Activity < ApplicationRecord
  enum :genre, { outdoor: 0, craft: 1 }

  has_many :time_slots, dependent: :restrict_with_error
  has_many :favorites, dependent: :destroy

  validates :title, presence: true
  validates :duration_minutes, numericality: { only_integer: true, greater_than: 0 }

  private

  def self.ransackable_attributes(_auth_object = nil)
    %w[title genre]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[time_slots]
  end
end
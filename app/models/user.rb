class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :avatar

  has_many :favorites, dependent: :destroy
  has_many :favorite_activities, through: :favorites, source: :activity
  has_many :assigned_activities, class_name: "Activity", foreign_key: :guide_id,
                                 inverse_of: :guide, dependent: :nullify

  enum :role, { guide: 0, manager: 1 }

  def full_name
    "#{last_name} #{first_name}"
  end

  private

  def self.ransackable_attributes(_auth_object = nil)
    %w[title genre]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[time_slots]
  end
end

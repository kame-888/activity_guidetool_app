class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :favorites, dependent: :destroy
  has_many :favorite_activities, through: :favorites, source: :activity
  has_many :assigned_time_slots, class_name: "TimeSlot", foreign_key: :guide_id,
                                 inverse_of: :guide, dependent: :nullify

  enum :role, { guide: 0, manager: 1 }

  def full_name
    "#{last_name} #{first_name}"
  end
end

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :avatar

  has_many :favorites, dependent: :destroy
  has_many :favorite_activities, through: :favorites, source: :activity

  enum :role, { guide: 0, manager: 1 }
end

# app/models/participant.rb
class Participant < ApplicationRecord
  enum :caution_category,
       { none: 0, allergy: 1, medical: 2, mobility: 3, other: 4 },
       prefix: :caution

  belongs_to :time_slot

  validates :name, presence: true
  validates :age, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :caution_detail, presence: true, unless: :caution_none?
end
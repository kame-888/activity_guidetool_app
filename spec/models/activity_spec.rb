require "rails_helper"

RSpec.describe Activity, type: :model do
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_numericality_of(:duration_minutes).only_integer.is_greater_than(0) }
end

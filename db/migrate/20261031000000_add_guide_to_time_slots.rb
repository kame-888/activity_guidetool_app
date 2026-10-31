class AddGuideToTimeSlots < ActiveRecord::Migration[7.2]
  def change
    add_reference :time_slots, :guide, null: true, foreign_key: { to_table: :users }
  end
end

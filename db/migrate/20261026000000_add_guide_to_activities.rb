class AddGuideToActivities < ActiveRecord::Migration[7.2]
  def change
    add_reference :activities, :guide, null: true, foreign_key: { to_table: :users }
  end
end

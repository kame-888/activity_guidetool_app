class RemoveGuideFromActivities < ActiveRecord::Migration[7.2]
  def change
    remove_reference :activities, :guide, null: true, foreign_key: { to_table: :users }, index: true
  end
end

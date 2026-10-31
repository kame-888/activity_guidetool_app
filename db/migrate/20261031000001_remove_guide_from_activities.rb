class RemoveGuideFromActivities < ActiveRecord::Migration[7.2]
  def up
    return unless column_exists?(:activities, :guide_id)
    
    # 担当ガイドは開催枠単位に移行したため、未割り当ての枠にアクティビティの担当を引き継ぐ
    execute <<~SQL
      UPDATE time_slots
      SET guide_id = (SELECT activities.guide_id FROM activities WHERE activities.id = time_slots.activity_id)
      WHERE guide_id IS NULL
    SQL

    remove_reference :activities, :guide, foreign_key: { to_table: :users }, index: true
  end

  def down
    add_reference :activities, :guide, null: true, foreign_key: { to_table: :users }
  end
end

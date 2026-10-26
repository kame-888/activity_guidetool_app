class CreateActivities < ActiveRecord::Migration[7.2]
  def change
    create_table :activities do |t|
      t.string :title, null: false
      t.integer :genre, null: false, default: 0
      t.integer :duration_minutes, null: false

      t.timestamps
    end
  end
end

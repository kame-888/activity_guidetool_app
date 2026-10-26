class CreateTimeSlots < ActiveRecord::Migration[7.2]
  def change
    create_table :time_slots do |t|
      t.references :activity, null: false, foreign_key: true
      t.datetime :starts_at, null: false
      t.datetime :ends_at, null: false
      t.integer :status, null: false, default: 0
      t.text :memo

      t.timestamps
    end

    add_index :time_slots, [ :activity_id, :starts_at ]
  end
end

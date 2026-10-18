class CreateParticipants < ActiveRecord::Migration[7.2]
  def change
    create_table :participants do |t|
      t.references :time_slot, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :age
      t.integer :caution_category, null: false, default: 0
      t.text :caution_detail

      t.timestamps
    end
  end
end
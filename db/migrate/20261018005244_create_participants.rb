class CreateParticipants < ActiveRecord::Migration[7.2]
  def change
    create_table :participants do |t|
      t.references :time_slot, null: false, foreign_key: true
      t.string :name
      t.integer :age
      t.integer :caution_category
      t.text :caution_detail

      t.timestamps
    end
  end
end

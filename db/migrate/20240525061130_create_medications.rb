class CreateMedications < ActiveRecord::Migration[7.1]
  def change
    create_table :medications do |t|
      t.string :name
      t.decimal :dose_amount
      t.string :dose_unit
      t.integer :amount_taken
      t.integer :amount_left
      t.date :last_picked_up
      t.string :icon
      t.string :color

      t.timestamps
    end
    add_index :medications, :name, unique: true
  end
end

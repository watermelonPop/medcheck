class CreateMedications < ActiveRecord::Migration[7.1]
  def change
    create_table :medications do |t|
      t.string :name
      t.integer :amount_taken
      t.string :dose
      t.integer :amount_left
      t.date :last_picked_up

      t.timestamps
    end
  end
end

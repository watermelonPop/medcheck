class CreateMedicationSchedules < ActiveRecord::Migration[7.1]
  def change
    create_table :medication_schedules do |t|
      t.references :medication, null: false, foreign_key: true
      t.references :day_of_week, null: false, foreign_key: true
      t.time :time

      t.timestamps
    end
  end
end

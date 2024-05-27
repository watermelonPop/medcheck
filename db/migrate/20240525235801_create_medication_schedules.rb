class CreateMedicationSchedules < ActiveRecord::Migration[7.1]
  def change
    create_table :medication_schedules do |t|
      t.time :time
      t.string :day_of_week
      t.boolean :taken

      t.timestamps
    end
  end
end

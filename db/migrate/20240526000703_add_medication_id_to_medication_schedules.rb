class AddMedicationIdToMedicationSchedules < ActiveRecord::Migration[7.1]
  def change
    add_column :medication_schedules, :medication_id, :integer
    add_foreign_key :medication_schedules, :medications
  end
end

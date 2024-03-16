class AddTakenToMedicationSchedules < ActiveRecord::Migration[7.1]
  def change
    add_column :medication_schedules, :taken, :boolean
  end
end

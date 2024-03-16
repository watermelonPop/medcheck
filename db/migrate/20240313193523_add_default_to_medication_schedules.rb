class AddDefaultToMedicationSchedules < ActiveRecord::Migration[7.1]
  def change
    change_column_default :medication_schedules, :taken, from: nil, to: false
  end
end

class AddMedicationScheduleRefToDaysTakens < ActiveRecord::Migration[7.1]
  def change
    add_reference :days_takens, :medication_schedule, null: false, foreign_key: true
  end
end

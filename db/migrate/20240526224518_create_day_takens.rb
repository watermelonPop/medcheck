class CreateDayTakens < ActiveRecord::Migration[7.1]
  def change
    create_table :day_takens do |t|
      t.string :date
      t.boolean :taken

      # Add the reference to medication_schedule
      t.references :user, null: false, foreign_key: true
      t.references :medication_schedule, null: false, foreign_key: true
      t.timestamps
    end
  end
end

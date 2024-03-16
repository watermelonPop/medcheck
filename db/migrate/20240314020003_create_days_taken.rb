class CreateDaysTaken < ActiveRecord::Migration[7.1]
  def change
    create_table :days_takens do |t|
      t.date :date_taken, null: false
      t.timestamps
    end
  end
end

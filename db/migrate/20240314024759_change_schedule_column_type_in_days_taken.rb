class ChangeScheduleColumnTypeInDaysTaken < ActiveRecord::Migration[7.1]
  def change
    change_column :days_takens, :schedule, :date
  end
end

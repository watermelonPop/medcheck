class AddEveryDayToDayOfWeek < ActiveRecord::Migration[7.1]
  def change
    DayOfWeek.create(name: 'Everyday')
  end
end

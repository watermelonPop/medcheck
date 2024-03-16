class DropDaysNotTaken < ActiveRecord::Migration[7.1]
  def change
    drop_table :days_not_takens
  end
end

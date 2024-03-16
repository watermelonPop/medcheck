class AddTakenToDaysTaken < ActiveRecord::Migration[7.1]
  def change
    add_column :days_takens, :taken, :boolean
  end
end

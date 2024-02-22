class AddIconAndColorToMedications < ActiveRecord::Migration[7.1]
  def change
    add_column :medications, :icon, :string
    add_column :medications, :color, :string
  end
end

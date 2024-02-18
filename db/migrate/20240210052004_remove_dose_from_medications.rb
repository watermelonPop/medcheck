class RemoveDoseFromMedications < ActiveRecord::Migration[7.1]
  def change
    remove_column :medications, :dose, :string
  end
end

class AddDoseAmountAndDoseUnitToMedications < ActiveRecord::Migration[7.1]
  def change
    add_column :medications, :dose_amount, :float
    add_column :medications, :dose_unit, :string
  end
end

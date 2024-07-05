class RemoveUniqueIndexFromMedicationsName < ActiveRecord::Migration[7.1]
  def up
    remove_index :medications, :name
    add_index :medications, :name, unique: false
  end

  def down
    remove_index :medications, :name
    add_index :medications, :name, unique: true
  end
end

class AddUserIdToMedications < ActiveRecord::Migration[7.1]
  def change
    add_column :medications, :user_id, :integer
    add_foreign_key :medications, :users
  end
end

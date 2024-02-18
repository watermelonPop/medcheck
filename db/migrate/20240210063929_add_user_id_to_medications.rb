class AddUserIdToMedications < ActiveRecord::Migration[7.1]
  def change
    add_reference :medications, :user, null: false, foreign_key: true
  end
end

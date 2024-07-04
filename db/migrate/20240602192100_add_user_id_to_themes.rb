class AddUserIdToThemes < ActiveRecord::Migration[7.1]
  def change
    add_column :themes, :user_id, :integer
  end
end

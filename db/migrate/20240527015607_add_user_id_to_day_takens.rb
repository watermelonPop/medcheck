class AddUserIdToDayTakens < ActiveRecord::Migration[7.1]
  def change
    add_column :day_takens, :user_id, :integer
  end
end

class AddCurrentThemeToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :current_theme_id, :integer
  end
end

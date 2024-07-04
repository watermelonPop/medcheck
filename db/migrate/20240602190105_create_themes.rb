class CreateThemes < ActiveRecord::Migration[7.1]
  def change
    create_table :themes do |t|
      t.string :name
      t.string :main_background
      t.string :schedule_background
      t.string :medication_background
      t.string :medication_main
      t.string :heading
      t.string :font

      t.timestamps
    end
  end
end

class CreateStations < ActiveRecord::Migration[7.0]
  def change
    create_table :stations do |t|
      t.float :x_Pos
      t.float :y_Pos
      t.integer :exit_Num
      t.string :name
      t.timestamps
    end
  end
end

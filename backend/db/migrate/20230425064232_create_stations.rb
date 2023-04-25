class CreateStations < ActiveRecord::Migration[7.0]
  def change
    create_table :stations do |t|
      t.string :linecolor
      t.integer :number
      t.float :x_Pos
      t.float :y_Pos
      t.integer :Trans_Num
      t.integer :exit_Num

      t.timestamps
    end
  end
end

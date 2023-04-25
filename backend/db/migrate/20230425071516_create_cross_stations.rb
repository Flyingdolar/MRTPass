class CreateCrossStations < ActiveRecord::Migration[7.0]
  def change
    create_table :cross_stations do |t|
      t.integer :number_1
      t.integer :number_2
      t.string :linecolor_1
      t.string :linecolor_2
      t.timestamps
    end
  end
end

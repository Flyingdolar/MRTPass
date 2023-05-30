class CreateStationNos < ActiveRecord::Migration[7.0]
  def change
    create_table :station_nos do |t|
      t.string :linecolor
      t.integer :number
      t.belongs_to :station , null: false, foreign_key: true
      t.timestamps
    end
  end
end

class CreateStationInfos < ActiveRecord::Migration[7.0]
  def change
    create_table :station_infos do |t|
      t.belongs_to :info , null: false, foreign_key: true
      t.string :linecolor
      t.integer :number
      t.timestamps
    end
  end
end

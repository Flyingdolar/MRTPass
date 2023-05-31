class CreateStationInfos < ActiveRecord::Migration[7.0]
  def change
    create_table :station_infos do |t|
      t.belongs_to :info , null: false, foreign_key: true
      t.belongs_to :station , null: false, foreign_key: true
      t.timestamps
    end
  end
end

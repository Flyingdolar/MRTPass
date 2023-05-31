class CreateTimeTables < ActiveRecord::Migration[7.0]
  def change
    create_table :time_tables do |t|
      t.string :time
      t.string :line
      t.integer :end
      t.integer :No
      t.belongs_to :station , null: false, foreign_key: true
      t.timestamps
    end
  end
end

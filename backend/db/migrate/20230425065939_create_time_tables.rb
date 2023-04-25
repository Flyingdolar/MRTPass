class CreateTimeTables < ActiveRecord::Migration[7.0]
  def change
    create_table :time_tables do |t|
      t.string :time
      t.string :line
      t.integer :end
      t.string :linecolor
      t.integer :number
      t.timestamps
    end
  end
end

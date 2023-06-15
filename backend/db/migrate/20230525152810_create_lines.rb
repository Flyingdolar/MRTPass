class CreateLines < ActiveRecord::Migration[7.0]
  def change
    create_table :lines do |t|
      t.string :linecolor
      t.string :name
      t.string :colorcode
      t.timestamps
    end
  end
end

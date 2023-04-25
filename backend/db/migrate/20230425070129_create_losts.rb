class CreateLosts < ActiveRecord::Migration[7.0]
  def change
    create_table :losts do |t|
      t.string :item
      t.string :photo
      t.string :time
      t.string :location
      t.string :lost_Attr
      t.belongs_to :member , null: false, foreign_key: true
      t.timestamps
    end
  end
end

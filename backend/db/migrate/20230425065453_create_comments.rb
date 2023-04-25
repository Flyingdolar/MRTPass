class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.string :photo
      t.text :comment
      t.integer :score
      t.belongs_to :member , null: false, foreign_key: true
      t.belongs_to :info , null: false, foreign_key: true
      t.timestamps
    end
  end
end

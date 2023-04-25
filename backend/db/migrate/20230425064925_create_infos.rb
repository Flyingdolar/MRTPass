class CreateInfos < ActiveRecord::Migration[7.0]
  def change
    create_table :infos do |t|
      t.string :name
      t.string :photo
      t.string :address
      t.float :score
      t.string :Des

      t.timestamps
    end
  end
end

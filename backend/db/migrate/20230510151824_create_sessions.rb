class CreateSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :sessions do |t|
      t.belongs_to :member , null: false, foreign_key: true
      t.timestamps
    end
  end
end

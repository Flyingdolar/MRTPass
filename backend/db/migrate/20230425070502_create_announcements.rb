class CreateAnnouncements < ActiveRecord::Migration[7.0]
  def change
    create_table :announcements do |t|
      t.string :topic
      t.text :context
      t.belongs_to :member , null: false, foreign_key: true
      t.timestamps
    end
  end
end

class AddColumnToCrossStation < ActiveRecord::Migration[7.0]
  def change
    add_column :cross_stations , :name , :string
  end
end

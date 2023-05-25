class AddColumnToStation < ActiveRecord::Migration[7.0]
  def change
    add_column :stations , :name , :string
  end
end

class AddColumnToTimetable < ActiveRecord::Migration[7.0]
  def change
    add_column :time_tables , :No , :integer
  end
end

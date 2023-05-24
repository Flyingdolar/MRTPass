class RenameRetypeInfo < ActiveRecord::Migration[7.0]
  def change
    rename_column :infos , :type , :type_
    change_column :infos , :Des  , :text
  end
end

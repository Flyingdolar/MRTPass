class RetypeStation < ActiveRecord::Migration[7.0]
  def change
    change_column :stations , :Trans_Num , :boolean
    rename_column :stations , :Trans_Num , :isCross
  end
end

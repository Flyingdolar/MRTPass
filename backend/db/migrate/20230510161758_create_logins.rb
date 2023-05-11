class CreateLogins < ActiveRecord::Migration[7.0]
  def change
    create_table :logins do |t|
      t.boolean :isLogin, null:false ,default:false
      t.timestamps
    end
  end
end

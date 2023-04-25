class CreateMembers < ActiveRecord::Migration[7.0]
  def change
    create_table :members do |t|
      t.string :account
      t.string :password
      t.string :nickname
      t.string :role
      t.string :picture

      t.timestamps
    end
  end
end

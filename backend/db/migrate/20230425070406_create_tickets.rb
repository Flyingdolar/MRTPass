class CreateTickets < ActiveRecord::Migration[7.0]
  def change
    create_table :tickets do |t|
      t.integer :price
      t.float :upper_bound
      t.float :lower_bound

      t.timestamps
    end
  end
end

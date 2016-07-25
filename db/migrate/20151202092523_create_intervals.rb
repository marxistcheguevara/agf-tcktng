class CreateIntervals < ActiveRecord::Migration
  def change
    create_table :intervals do |t|
      t.integer :cashier_id
      t.integer :event_id
      t.integer :from
      t.integer :to

      t.timestamps null: false
    end
  end
end

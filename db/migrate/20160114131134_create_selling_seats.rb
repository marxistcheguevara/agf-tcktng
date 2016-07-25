class CreateSellingSeats < ActiveRecord::Migration
  def change
    create_table :selling_seats do |t|
      t.integer :event_id
      t.integer :seat_id
      t.integer :color_id
      t.float :price
      t.integer :ticket_type_id

      t.timestamps null: false
    end
  end
end

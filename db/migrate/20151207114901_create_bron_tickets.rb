class CreateBronTickets < ActiveRecord::Migration
  def change
    create_table :bron_tickets do |t|
      t.integer :event_id
      t.integer :cashier_id
      t.integer :sector
      t.string :place

      t.timestamps null: false
    end
  end
end

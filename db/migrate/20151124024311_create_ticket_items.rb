class CreateTicketItems < ActiveRecord::Migration
  def change
    create_table :ticket_items do |t|
      t.integer :event_id
      t.integer :cat_id
      t.integer :sector
      t.string :place

      t.timestamps null: false
    end
  end
end

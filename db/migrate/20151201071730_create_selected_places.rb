class CreateSelectedPlaces < ActiveRecord::Migration
  def change
    create_table :selected_places do |t|
      t.integer :cashier_id
      t.integer :event_id
      t.string :sector
      t.string :place

      t.timestamps null: false
    end
  end
end

class CreateEntrances < ActiveRecord::Migration
  def change
    create_table :entrances do |t|
      t.integer :sector_number
      t.integer :event_id
      t.string :entrance_text

      t.timestamps null: false
    end
  end
end

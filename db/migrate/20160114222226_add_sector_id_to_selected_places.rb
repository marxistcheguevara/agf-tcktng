class AddSectorIdToSelectedPlaces < ActiveRecord::Migration
  def change
    add_column :selected_places, :seat_sector_id, :integer
  end
end

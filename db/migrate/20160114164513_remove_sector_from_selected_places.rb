class RemoveSectorFromSelectedPlaces < ActiveRecord::Migration
  def change
    remove_column :selected_places, :sector
  end
end

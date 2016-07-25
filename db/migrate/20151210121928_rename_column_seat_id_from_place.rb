class RenameColumnSeatIdFromPlace < ActiveRecord::Migration
  def change
    rename_column :selected_places, :place, :seat_id
  end
end

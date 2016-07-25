class ChangeSectorNumberTosectorIdOnEntrances < ActiveRecord::Migration
  def change
    rename_column :entrances, :sector_number, :sector_id
  end
end

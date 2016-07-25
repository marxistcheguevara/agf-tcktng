class AddSectorIdToTicketItems < ActiveRecord::Migration
  def change
    add_column :ticket_items, :seat_sector_id, :integer
  end
end

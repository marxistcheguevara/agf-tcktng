class AddSectorIdToBronTickets < ActiveRecord::Migration
  def change
    add_column :bron_tickets, :seat_sector_id, :integer
  end
end

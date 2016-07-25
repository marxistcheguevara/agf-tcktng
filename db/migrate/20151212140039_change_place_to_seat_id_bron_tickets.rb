class ChangePlaceToSeatIdBronTickets < ActiveRecord::Migration
  def change
    rename_column :bron_tickets, :place, :seat_id
  end
end

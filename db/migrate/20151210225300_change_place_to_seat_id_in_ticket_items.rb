class ChangePlaceToSeatIdInTicketItems < ActiveRecord::Migration
  def change
    rename_column :ticket_items, :place, :seat_id
  end
end

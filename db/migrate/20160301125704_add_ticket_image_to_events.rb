class AddTicketImageToEvents < ActiveRecord::Migration
  def change
    add_column :events, :ticketimage, :text
  end
end

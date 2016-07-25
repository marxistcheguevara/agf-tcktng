class AddTicketTypeToTickets < ActiveRecord::Migration
  def change
    add_column :ticket_items, :ticket_type, :string
    add_column :ticket_items, :ticket_image, :string
  end
end

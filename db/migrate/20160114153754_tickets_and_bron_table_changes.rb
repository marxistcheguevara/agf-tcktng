class TicketsAndBronTableChanges < ActiveRecord::Migration
  def change
    # tickets table changes
    remove_column     :ticket_items, :cat_id
    remove_column     :ticket_items, :sector
    rename_column     :ticket_items, :deleted, :invalid
    add_column        :ticket_items, :entrance, :string
    add_column        :ticket_items, :sector, :string
    add_column        :ticket_items, :row, :string
    add_column        :ticket_items, :column, :string
    add_column        :ticket_items, :price, :string

    # bron table changes
    remove_column     :bron_tickets, :sector
    remove_column     :bron_tickets, :cashier_id
    add_column        :bron_tickets, :closed_by, :integer
    add_column        :bron_tickets, :opened_by, :integer
    add_column        :bron_tickets, :fullName, :string
    add_column        :bron_tickets, :expiry_date, :timestamp
  end
end

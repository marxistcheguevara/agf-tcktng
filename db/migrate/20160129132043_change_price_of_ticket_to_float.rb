class ChangePriceOfTicketToFloat < ActiveRecord::Migration
  def change
    remove_column :ticket_items, :price
    add_column :ticket_items, :price, :decimal, precision: 5, scale: 2
  end
end

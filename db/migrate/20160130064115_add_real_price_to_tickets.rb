class AddRealPriceToTickets < ActiveRecord::Migration
  def change
    add_column :ticket_items, :real_price, :decimal, precision: 5, scale: 2
  end
end

class AddInvoiceItToTickets < ActiveRecord::Migration
  def change
    add_column :ticket_items, :imvoice_id, :integer
  end
end

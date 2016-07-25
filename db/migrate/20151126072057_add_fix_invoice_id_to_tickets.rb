class AddFixInvoiceIdToTickets < ActiveRecord::Migration
  def change
    rename_column :ticket_items, :imvoice_id, :invoice_id
  end
end

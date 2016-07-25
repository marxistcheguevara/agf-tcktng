class AddEventIdToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :event_id, :integer
  end
end

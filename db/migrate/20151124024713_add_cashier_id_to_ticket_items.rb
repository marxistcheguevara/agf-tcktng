class AddCashierIdToTicketItems < ActiveRecord::Migration
  def change
    add_column :ticket_items, :cashier_id, :integer
  end
end

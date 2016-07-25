class AddDeletedToTicketItems < ActiveRecord::Migration
  def change
    add_column :ticket_items, :deleted, :boolean
  end
end

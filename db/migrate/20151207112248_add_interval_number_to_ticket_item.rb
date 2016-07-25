class AddIntervalNumberToTicketItem < ActiveRecord::Migration
  def change
    add_column :ticket_items, :interval_number, :integer
  end
end

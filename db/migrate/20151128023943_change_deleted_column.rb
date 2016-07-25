class ChangeDeletedColumn < ActiveRecord::Migration
  def change
    change_column :ticket_items, :deleted, :boolean, default: false
  end
end

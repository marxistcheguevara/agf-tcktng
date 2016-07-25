class ChangeInvalidToIsInvalid < ActiveRecord::Migration
  def change
    rename_column :ticket_items, :invalid, :is_invalid
  end
end
